// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables

part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class AddProductLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  DashboardLoaded(
    this.productModel,
  );

  ProductModel? productModel;
  @override
  List<Object> get props => [
        productModel!,
      ];
}

class DashboardFailure extends DashboardState {
  DashboardFailure(
    this.error,
  );

  String error;
  @override
  List<Object> get props => [error];
}

class ProductAdded extends DashboardState {
  final AddProductModel addProductModel;

  ProductAdded({required this.addProductModel});

  @override
  List<Object> get props => [addProductModel];
}

class ProductAddFailure extends DashboardState {
  final String error;

  ProductAddFailure(this.error);

  @override
  List<Object> get props => [error];
}
