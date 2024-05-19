import 'dart:convert';

import 'package:flutter_application_1/features/product/data/models/product_detail_model.dart';
import 'package:flutter_application_1/framework/core/exceptions/app_exception.dart';
import 'package:http/http.dart' as http;

abstract class ProductRemoteDataSource {
  Future<ProductDetailModel> productDetail(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductDetailModel> productDetail(int id) async {
    final Uri url = Uri.parse('https://dummyjson.com/products/$id');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> dataBody = jsonDecode(response.body);
      return ProductDetailModel.fromJson(dataBody);
    } else {
      throw ServerException();
    }
  }
}
