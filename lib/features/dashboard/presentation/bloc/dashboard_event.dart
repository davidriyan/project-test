// ignore_for_file: prefer_const_constructors_in_immutables

part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class LoadAddProduct extends DashboardEvent {
  final String title;
  final String brand;
  final String category;
  final String thumbnail;

  LoadAddProduct({
    required this.title,
    required this.brand,
    required this.category,
    required this.thumbnail,
  });

  @override
  List<Object> get props => [title, brand, category, thumbnail];
}
