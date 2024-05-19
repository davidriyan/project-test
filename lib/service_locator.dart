import 'package:flutter_application_1/features/product/data/datasources/product_local_datasource.dart';
import 'package:flutter_application_1/features/product/data/datasources/product_remote_datasource.dart';
import 'package:flutter_application_1/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_application_1/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_application_1/features/product/presentation/bloc/product_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:flutter_application_1/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:flutter_application_1/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:flutter_application_1/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_application_1/features/dashboard/presentation/bloc/dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! DASHBOARD
  // Blocs
  sl.registerFactory(
    () => DashboardBloc(
      dashboardRepository: sl(),
      dashboardRemoteDataSource: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      dashboardRemoteDataSource: sl(),
      dashboardLocalDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSourceImpl(hive: Hive),
  );

  //! PRODUCT
  // Blocs
  sl.registerFactory(
    () => ProductBloc(
      productRepository: sl(),
      productRemoteDataSource: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      productRemoteDataSource: sl(),
      productLocalDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(hive: Hive),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}
