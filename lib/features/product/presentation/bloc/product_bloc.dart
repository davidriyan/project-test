import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/product/data/datasources/product_remote_datasource.dart';
import 'package:flutter_application_1/features/product/data/models/product_detail_model.dart';
import 'package:flutter_application_1/features/product/data/models/product_update_model.dart';
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
    on<LoadUpdateProduct>(_onLoadUpdateProduct);
  }

  //! GET DATA BY ID
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

  //! UPDATE DATA BY ID
  void _onLoadUpdateProduct(
      LoadUpdateProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    try {
      final productUpdateModel =
          await productUpdate(event.id, event.title, event.brand);
      emit(ProductUpdateLoaded(productUpdateModel: productUpdateModel));
    } catch (e) {
      emit(ProductUpdateFailure('Failed to update product'));
    }
  }

  Future<ProductUpdateModel> productUpdate(
      int id, String title, String brand) async {
    final productUpdateModel =
        await productRemoteDataSource.productUpdate(id, title, brand);
    return productUpdateModel;
  }
}
