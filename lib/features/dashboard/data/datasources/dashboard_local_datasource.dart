import 'package:flutter_application_1/features/dashboard/data/models/add_product_model.dart';
import 'package:flutter_application_1/features/dashboard/data/models/product_model.dart';
import 'package:hive/hive.dart';

abstract class DashboardLocalDataSource {
  Future<ProductModel> getListProduct();
  Future<AddProductModel> addProduct(
      String title, String brand, String category, String thumbnail);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final HiveInterface hive;

  DashboardLocalDataSourceImpl({required this.hive});

  @override
  Future<ProductModel> getListProduct() async {
    var box = hive.box('product');
    final productJson = box.get('getListProduct');
    if (productJson != null) {
      return ProductModel.fromJson(productJson);
    } else {
      throw Exception('No data found');
    }
  }

  @override
  Future<AddProductModel> addProduct(
      String title, String brand, String category, String thumbnail) async {
    var box = hive.box('product');
    final productDetailJson = box.get('productDetail');
    if (productDetailJson != null) {
      return AddProductModel.fromJson(productDetailJson);
    } else {
      throw Exception('No data found');
    }
  }
}
