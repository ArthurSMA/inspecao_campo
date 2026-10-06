import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:inspecao_campo/core/network/dio_client.dart';
import 'package:inspecao_campo/core/presentation/widgets/app_header.dart';
import 'package:inspecao_campo/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:inspecao_campo/core/utils/colors.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_event.dart';
import 'package:inspecao_campo/features/auth/presentation/bloc/auth_state.dart';
import 'package:inspecao_campo/features/home/presentation/pages/home_page.dart';
import 'package:inspecao_campo/features/map/presentation/pages/map_page.dart';
import 'package:inspecao_campo/features/work_orders/data/database/work_orders_database.dart';
import 'package:inspecao_campo/features/work_orders/data/datasources/work_orders_remote_data_source.dart';
import 'package:inspecao_campo/features/work_orders/data/repositories/work_orders_repository_impl.dart';
import 'package:inspecao_campo/features/work_orders/domain/entities/work_order.dart'
    as domain;
import 'package:inspecao_campo/features/work_orders/domain/usecases/get_work_orders.dart';

import '../bloc/work_orders_bloc.dart';
import '../bloc/work_orders_event.dart';
import '../bloc/work_orders_state.dart';
import '../widgets/database_status_banner.dart';
import '../widgets/work_order_card.dart';
import '../widgets/work_orders_filter_chips.dart';
import '../widgets/work_orders_footer.dart';
import '../widgets/work_orders_search_bar.dart';

class WorkOrdersPage extends StatefulWidget {
  const WorkOrdersPage({super.key});

  @override
  State<WorkOrdersPage> createState() => _WorkOrdersPageState();
}

class _WorkOrdersPageState extends State<WorkOrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const HomePage()),
        );
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BlocProvider.value(
              value: context.read<WorkOrdersBloc>(),
              child: const MapPage(),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkOrdersBloc(
        GetWorkOrdersUseCase(
          WorkOrdersRepositoryImpl(
            remoteDataSource: WorkOrdersRemoteDataSourceImpl(
              DioClient().instance,
            ),
            database: AppDatabase(),
          ),
        ),
      )..add(FetchWorkOrdersEvent()),
      child: Builder(
        builder: (pageContext) => Scaffold(
          backgroundColor: AppColors.bgLight,
          body: SafeArea(
            child: BlocBuilder<WorkOrdersBloc, WorkOrdersState>(
              buildWhen: (previous, current) =>
                  previous.runtimeType != current.runtimeType ||
                  previous != current,
              builder: (context, state) {
                final loadedOrders = state is WorkOrdersLoadedState
                    ? state.orders
                    : const <domain.WorkOrder>[];

                return Column(
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, authState) {
                        final user = authState is AuthSuccessState
                            ? authState.user
                            : null;
                        return AppHeader(
                          title: 'Ordens De Serviço',
                          userName: user?.name ?? 'Usuário',
                          userRole: user?.role ?? 'Técnico de campo',
                          onLogout: _handleLogout,
                          onSync: () => context.read<WorkOrdersBloc>().add(
                            FetchWorkOrdersEvent(),
                          ),
                        );
                      },
                    ),
                    WorkOrdersSearchBar(
                      controller: _searchController,
                      onChanged: (query) {
                        context.read<WorkOrdersBloc>().add(
                          SearchWorkOrdersEvent(query),
                        );
                      },
                      onClear: () {
                        _searchController.clear();
                        context.read<WorkOrdersBloc>().add(
                          SearchWorkOrdersEvent(''),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    WorkOrdersFilterChips(
                      selectedFilter: _selectedFilter,
                      onFilterSelected: (filter) {
                        setState(() => _selectedFilter = filter);
                        context.read<WorkOrdersBloc>().add(
                          FilterByStatusEvent(filter),
                        );
                      },
                    ),
                    const DatabaseStatusBanner(),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<WorkOrdersBloc>().add(
                            FetchWorkOrdersEvent(),
                          );
                        },
                        child: state is WorkOrdersLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : state is WorkOrdersErrorState
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: AppColors.danger,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        state.message,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: AppColors.darkText,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      FilledButton.icon(
                                        onPressed: () => context
                                            .read<WorkOrdersBloc>()
                                            .add(FetchWorkOrdersEvent()),
                                        icon: const Icon(Icons.refresh_rounded),
                                        label: const Text('Tentar novamente'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : loadedOrders.isEmpty
                            ? const Center(
                                child: Text(
                                  'Nenhuma ordem de serviço encontrada.',
                                  style: TextStyle(color: AppColors.muted),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 16),
                                itemCount: loadedOrders.length,
                                itemBuilder: (context, index) {
                                  final order = loadedOrders[index];
                                  return WorkOrderCard(order: order);
                                },
                              ),
                      ),
                    ),
                    WorkOrdersFooter(
                      visibleCount: loadedOrders.length,
                      totalCount: loadedOrders.length,
                    ),
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            selectedIndex: 2,
            onDestinationSelected: (index) =>
                _handleNavigation(pageContext, index),
          ),
        ),
      ),
    );
  }
}
