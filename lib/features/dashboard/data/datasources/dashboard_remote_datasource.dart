import 'dart:convert';
import 'package:flutter_application_1/features/dashboard/data/models/add_product_model.dart';
import 'package:flutter_application_1/features/dashboard/data/models/product_model.dart';
import 'package:flutter_application_1/framework/core/exceptions/app_exception.dart';
import 'package:http/http.dart' as http;

abstract class DashboardRemoteDataSource {
  Future<ProductModel> getListProduct();
  Future<AddProductModel> addProduct(
      String title, String brand, String category, String thumbnail);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final http.Client client;

  DashboardRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductModel> getListProduct() async {
    final Uri url = Uri.parse('https://dummyjson.com/products');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> dataBody = json.decode(response.body);
      return ProductModel.fromJson(dataBody);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AddProductModel> addProduct(
      String title, String brand, String category, String thumbnail) async {
    final Uri url = Uri.parse('https://dummyjson.com/products/add');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'brand': brand,
        'category': category,
        'thumbnail': thumbnail,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> dataBody = json.decode(response.body);
      return AddProductModel.fromJson(dataBody);
    } else {
      throw ServerException();
    }
  }
}
