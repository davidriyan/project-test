// ignore_for_file: prefer_const_constructors_in_immutables

part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProduct extends ProductEvent {
  LoadProduct({required this.id});

  final int id;
  @override
  List<Object> get props => [id];
}

class LoadUpdateProduct extends ProductEvent {
  LoadUpdateProduct(
      {required this.id, required this.title, required this.brand});

  final int id;
  final String title;
  final String brand;
  @override
  List<Object> get props => [id, title, brand];
}
