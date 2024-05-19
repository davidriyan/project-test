import 'package:flutter_application_1/features/product/data/models/product_detail_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ProductLocalDataSource {
  Future<ProductDetailModel> productDetail(int id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final HiveInterface hive;

  ProductLocalDataSourceImpl({
    required this.hive,
  });
  @override
  Future<ProductDetailModel> productDetail(int id) async {
    var box = hive.box('product');
    final productDetailJson = box.get('productDetail');
    if (productDetailJson != null) {
      return ProductDetailModel.fromJson(productDetailJson);
    } else {
      throw Exception('No data found');
    }
  }
}
