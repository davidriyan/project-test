import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/product/data/datasources/product_remote_datasource.dart';
import 'package:flutter_application_1/features/product/data/models/product_detail_model.dart';
import 'package:flutter_application_1/features/product/domain/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  final ProductRemoteDataSource productRemoteDataSource;

  ProductBloc({
    required this.productRepository,
    required this.productRemoteDataSource,
  }) : super(ProductInitial()) {
    on<LoadProduct>(_onLoadProductDetail);
  }

  void _onLoadProductDetail(
      LoadProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    try {
      final productDetailModel = await _fetchProductDetail(event.id);
      emit(ProductLoaded(productDetailModel: productDetailModel));
    } catch (e) {
      emit(ProductFailure('Failed to load data'));
    }
  }

  Future<ProductDetailModel> _fetchProductDetail(int id) async {
    // Panggil API untuk mendapatkan detail produk berdasarkan ID
    final productDetailModel = await productRemoteDataSource.productDetail(id);
    // Kembalikan objek ProductDetailModel
    return productDetailModel;
  }
}
