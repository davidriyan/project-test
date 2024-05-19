// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  ProductLoaded({
    this.productDetailModel,
  });
  ProductDetailModel? productDetailModel;

  @override
  List<Object> get props => [
        productDetailModel!,
      ];
}

class ProductFailure extends ProductState {
  ProductFailure(
    this.error,
  );

  String error;
  @override
  List<Object> get props => [error];
}
