import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inpecao_campo/core/network/dio_client.dart';
import 'package:inpecao_campo/features/work_orders/data/work_orders_repository.dart';
import 'package:inpecao_campo/features/work_orders/data/datasources/work_orders_remote_data_source.dart';
import 'package:inpecao_campo/features/work_orders/domain/usecases/get_work_orders.dart';

import '../bloc/work_orders_bloc.dart';
import '../bloc/work_orders_event.dart';
import '../bloc/work_orders_state.dart';

class WorkOrdersPage extends StatelessWidget {
  const WorkOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WorkOrdersBloc(
            GetWorkOrdersUseCase(
              WorkOrdersRepositoryImpl(
                remoteDataSource: WorkOrdersRemoteDataSourceImpl(
                  DioClient().instance,
                ),
              ),
            ),
          )..add(FetchWorkOrdersEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ordens de Serviço')),
        body: BlocBuilder<WorkOrdersBloc, WorkOrdersState>(
          builder: (context, state) {
            if (state is WorkOrdersLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is WorkOrdersLoadedState) {
              if (state.orders.isEmpty) {
                return const Center(child: Text('Nenhuma ordem de serviço.'));
              }

              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(order.id)),
                    title: Text(order.title),
                    subtitle: Text(order.description),
                    trailing: Chip(label: Text(order.status)),
                  );
                },
              );
            }

            if (state is WorkOrdersErrorState) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
              size: 32,
              color: Colors.black87,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const Expanded(
            child: Text(
              'Início',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004B93),
              ),
            ),
          ),
          const Icon(Icons.person_rounded, size: 32),
        ],
      ),
    );
  }
}
