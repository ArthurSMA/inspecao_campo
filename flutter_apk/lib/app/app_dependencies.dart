import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/network/dio_client.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/work_orders/data/database/work_orders_database.dart';
import '../features/work_orders/data/datasources/inspection_remote_data_source.dart';
import '../features/work_orders/data/datasources/work_orders_remote_data_source.dart';
import '../features/work_orders/data/repositories/inspection_repository_impl.dart';
import '../features/work_orders/data/repositories/work_orders_repository_impl.dart';
import '../features/work_orders/domain/repositories/inspection_repository.dart';
import '../features/work_orders/domain/repositories/work_orders_repository.dart';
import '../features/work_orders/domain/usecases/get_work_orders.dart';
import '../features/work_orders/presentation/bloc/inspection_bloc.dart';
import '../features/work_orders/presentation/bloc/work_orders_bloc.dart';

class AppDependencies {
  const AppDependencies({
    required this.authBloc,
    required this.inspectionBloc,
    required this.workOrdersBloc,
    required this.database,
    required this.inspectionRepository,
    required this.workOrdersRepository,
  });

  final AuthBloc authBloc;
  final InspectionBloc inspectionBloc;
  final WorkOrdersBloc workOrdersBloc;
  final AppDatabase database;
  final InspectionRepository inspectionRepository;
  final WorkOrdersRepository workOrdersRepository;
}

class AppDependenciesFactory {
  static AppDependencies create() {
    final apiClient = ApiClient();
    final database = AppDatabase();

    final authRepository = AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(
        apiClient,
        secureStorage: const FlutterSecureStorage(),
      ),
    );
    final inspectionRepository = InspectionRepositoryImpl(
      remoteDataSource: InspectionRemoteDataSourceImpl(apiClient.instance),
      database: database,
    );
    final workOrdersRepository = WorkOrdersRepositoryImpl(
      remoteDataSource: WorkOrdersRemoteDataSourceImpl(apiClient.instance),
      database: database,
    );

    final authBloc = AuthBloc(repository: authRepository)
      ..add(CheckAuthSessionEvent());
    final inspectionBloc = InspectionBloc(inspectionRepository);
    final workOrdersBloc = WorkOrdersBloc(
      GetWorkOrdersUseCase(workOrdersRepository),
    );

    return AppDependencies(
      authBloc: authBloc,
      inspectionBloc: inspectionBloc,
      workOrdersBloc: workOrdersBloc,
      database: database,
      inspectionRepository: inspectionRepository,
      workOrdersRepository: workOrdersRepository,
    );
  }
}
