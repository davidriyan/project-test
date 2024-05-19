// ignore_for_file: unrelated_type_equality_checks

import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:flutter_application_1/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:flutter_application_1/features/dashboard/data/models/add_product_model.dart';
import 'package:flutter_application_1/features/dashboard/data/models/product_model.dart';
import 'package:flutter_application_1/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_application_1/framework/core/exceptions/failure.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardRemoteDataSource dashboardRemoteDataSource;
  final DashboardLocalDataSource dashboardLocalDataSource;

  DashboardRepositoryImpl({
    required this.dashboardRemoteDataSource,
    required this.dashboardLocalDataSource,
  });

  @override
  Future<Either<Failure, ProductModel>> getListProduct() async {
    try {
      // Check internet
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        // Mengambil data dari remote
        final productModel = await dashboardRemoteDataSource.getListProduct();
        // var box = Hive.box('product');
        // box.put('getListProduct', productModel.toJson());
        return Right(productModel);
      } else {
        // Mengambil data dari lokal
        final productModel = await dashboardLocalDataSource.getListProduct();
        return Right(productModel);
      }
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, AddProductModel>> addProduct(
      String title, String brand, String category, String thumbnail) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult != ConnectivityResult.none) {
        // Mengambil data remote
        final productDetailModel = await dashboardRemoteDataSource.addProduct(
            title, brand, category, thumbnail);
        //menyimpan kedalam local
        // var box = Hive.box('productDetail');
        // box.put('productDetail', productDetailModel.toJson());
        return Right(productDetailModel);
      } else {
        // Mengambil data dari lokal
        final productDetailModel = await dashboardLocalDataSource.addProduct(
            title, brand, category, thumbnail);
        return Right(productDetailModel);
      }
    } catch (e) {
      return const Left(Failure());
    }
  }
}
