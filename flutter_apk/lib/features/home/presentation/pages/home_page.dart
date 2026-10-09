import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inspecao_campo/core/network/dio_client.dart';
import 'package:inspecao_campo/core/presentation/widgets/app_header.dart';
import 'package:inspecao_campo/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:inspecao_campo/core/presentation/widgets/sync_status_card.dart';
import 'package:inspecao_campo/core/utils/colors.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_event.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_state.dart';
import 'package:inspecao_campo/features/home/presentation/widgets/metric_grid.dart';
import 'package:inspecao_campo/features/home/presentation/widgets/priority_work_order_card.dart';
import 'package:inspecao_campo/features/home/presentation/widgets/quick_access_grid.dart';
import 'package:inspecao_campo/features/work_orders/data/database/work_orders_database.dart';
import 'package:inspecao_campo/features/work_orders/data/datasources/inspection_remote_data_source.dart';
import 'package:inspecao_campo/features/work_orders/data/datasources/work_orders_remote_data_source.dart';
import 'package:inspecao_campo/features/work_orders/data/repositories/inspection_repository_impl.dart';
import 'package:inspecao_campo/features/work_orders/data/repositories/work_orders_repository_impl.dart';
import 'package:inspecao_campo/features/work_orders/domain/entities/work_order.dart';
import 'package:inspecao_campo/features/work_orders/domain/usecases/get_work_orders.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_bloc.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_event.dart';
import 'package:inspecao_campo/features/work_orders/presentation/bloc/work_orders_state.dart';
import 'package:inspecao_campo/features/work_orders/presentation/pages/work_orders_page.dart';
import 'package:inspecao_campo/features/map/presentation/pages/map_page.dart';

import 'inspection_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppDatabase _database;
  late final InspectionRepositoryImpl _inspectionRepository;
  late final WorkOrdersRepositoryImpl _workOrdersRepository;
  late Future<int> _pendingCount;
  bool _isSyncing = false;
  bool? _isConnected;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _inspectionRepository = InspectionRepositoryImpl(
      remoteDataSource: InspectionRemoteDataSourceImpl(ApiClient().instance),
      database: _database,
    );
    _workOrdersRepository = WorkOrdersRepositoryImpl(
      remoteDataSource: WorkOrdersRemoteDataSourceImpl(ApiClient().instance),
      database: _database,
    );
    _pendingCount = _loadPendingCount();
  }

  Future<int> _loadPendingCount() async {
    final pending = await _database.getInspections(status: 'pending');
    final failed = await _database.getInspections(status: 'failed');
    return pending.length + failed.length;
  }

  Future<void> _syncNow(BuildContext context) async {
    setState(() => _isSyncing = true);
    try {
      await _workOrdersRepository.syncRemoteOrders();
      if (mounted) {
        setState(() => _isConnected = true);
      }
      await _inspectionRepository.syncPendingInspections();
      if (!context.mounted) {
        return;
      }
      context.read<WorkOrdersBloc>().add(FetchWorkOrdersEvent());
      setState(() => _pendingCount = _loadPendingCount());
    } catch (_) {
      if (!context.mounted) return;

      setState(() => _isConnected = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível sincronizar os dados.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  void _openWorkOrders() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const WorkOrdersPage()));
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BlocProvider.value(
              value: context.read<WorkOrdersBloc>(),
              child: const MapPage(),
            ),
          ),
        );
      case 2:
        _openWorkOrders();
    }
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  WorkOrder? _priorityOrder(List<WorkOrder> orders) {
    final activeOrders =
        orders.where((order) => order.status != 'done').toList()
          ..sort((first, second) {
            const priority = {'high': 0, 'medium': 1, 'low': 2};
            return (priority[first.priority.toLowerCase()] ?? 3).compareTo(
              priority[second.priority.toLowerCase()] ?? 3,
            );
          });
    return activeOrders.isEmpty ? null : activeOrders.first;
  }

  int _completed(List<WorkOrder> orders) {
    return orders.where((order) {
      return order.status == 'done';
    }).length;
  }

  @override
  void dispose() {
    unawaited(_database.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          WorkOrdersBloc(GetWorkOrdersUseCase(_workOrdersRepository))
            ..add(FetchWorkOrdersEvent()),
      child: Builder(
        builder: (pageContext) => Scaffold(
          backgroundColor: AppColors.bgLight,
          appBar: null,
          body: SafeArea(
            child: Column(
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) {
                    final previousUser = previous is AuthSuccessState
                        ? previous.user
                        : null;
                    final currentUser = current is AuthSuccessState
                        ? current.user
                        : null;
                    return previousUser != currentUser;
                  },
                  builder: (context, authState) {
                    final user = authState is AuthSuccessState
                        ? authState.user
                        : null;
                    return AppHeader(
                      title: 'Início',
                      userName: user?.name ?? 'Usuário',
                      userRole: user?.role ?? 'Técnico de campo',
                      onLogout: _handleLogout,
                      onSync: () => _syncNow(pageContext),
                    );
                  },
                ),
                Expanded(
                  child: BlocBuilder<WorkOrdersBloc, WorkOrdersState>(
                    buildWhen: (previous, current) =>
                        previous.runtimeType != current.runtimeType ||
                        previous != current,
                    builder: (context, state) {
                      final orders = state is WorkOrdersLoadedState
                          ? state.orders
                          : const <WorkOrder>[];
                      final priorityOrder = _priorityOrder(orders);

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<int>(
                              future: _pendingCount,
                              builder: (context, snapshot) => SyncStatusCard(
                                pendingCount: snapshot.data ?? 0,
                                isSyncing: _isSyncing,
                                isConnected: _isConnected,
                                onSync: () => _syncNow(pageContext),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const _SectionTitle(title: 'Resumo'),
                            const SizedBox(height: 12),
                            MetricsGrid(
                              completed: _completed(orders),
                              openCount: orders
                                  .where((order) => order.status != 'done')
                                  .length,
                            ),
                            const SizedBox(height: 24),
                            const _SectionTitle(title: 'Ordem prioritária'),
                            const SizedBox(height: 12),
                            if (state is WorkOrdersLoadingState)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else
                              PriorityWorkOrderCard(
                                workOrder: priorityOrder,
                                onStartInspection: _openWorkOrders,
                              ),
                            const SizedBox(height: 24),
                            const _SectionTitle(title: 'Acesso rápido'),
                            const SizedBox(height: 12),
                            QuickAccessGrid(
                              onAllWorkOrders: _openWorkOrders,
                              onHistory: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const InspectionHistoryPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            selectedIndex: 0,
            onDestinationSelected: (index) =>
                _handleNavigation(pageContext, index),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.darkText,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
