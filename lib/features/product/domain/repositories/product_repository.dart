import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/features/product/data/models/product_detail_model.dart';
import 'package:flutter_application_1/framework/core/exceptions/failure.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductDetailModel>> productDetail(int id);
}
