// ignore_for_file: unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/features/product/data/datasources/product_local_datasource.dart';
import 'package:flutter_application_1/features/product/data/datasources/product_remote_datasource.dart';
import 'package:flutter_application_1/features/product/data/models/product_detail_model.dart';
import 'package:flutter_application_1/features/product/data/models/product_update_model.dart';
import 'package:flutter_application_1/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_application_1/framework/core/exceptions/failure.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource productRemoteDataSource;
  final ProductLocalDataSource productLocalDataSource;

  ProductRepositoryImpl({
    required this.productRemoteDataSource,
    required this.productLocalDataSource,
  });

  @override
  Future<Either<Failure, ProductDetailModel>> productDetail(int id) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult != ConnectivityResult.none) {
        // Mengambil data remote
        final productDetailModel =
            await productRemoteDataSource.productDetail(id);
        //menyimpan kedalam local
        // var box = Hive.box('productDetail');
        // box.put('productDetail', productDetailModel.toJson());
        return Right(productDetailModel);
      } else {
        // Mengambil data dari lokal
        final productDetailModel =
            await productLocalDataSource.productDetail(id);
        return Right(productDetailModel);
      }
    } catch (e) {
      return const Left(Failure());
    }
  }

  @override
  Future<Either<Failure, ProductUpdateModel>> productUpdate(
      int id, String title, String brand) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      // Mengambil data remote
      final productDetailModel =
          await productRemoteDataSource.productUpdate(id, title, brand);
      //menyimpan kedalam local
      // var box = Hive.box('productDetail');
      // box.put('productDetail', productDetailModel.toJson());
      return Right(productDetailModel);
    } else {
      return const Left(Failure());
    }
  }
}
