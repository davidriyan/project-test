import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/features/dashboard/data/models/add_product_model.dart';
import 'package:flutter_application_1/features/dashboard/data/models/product_model.dart';
import 'package:flutter_application_1/framework/core/exceptions/failure.dart';

abstract class DashboardRepository {
  Future<Either<Failure, ProductModel>> getListProduct();
  Future<Either<Failure, AddProductModel>> addProduct(
      String title, String brand, String category, String thumbnail);
}
