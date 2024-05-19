import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:flutter_application_1/features/dashboard/data/models/product_model.dart';
import 'package:flutter_application_1/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_application_1/features/dashboard/data/models/add_product_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;
  final DashboardRemoteDataSource dashboardRemoteDataSource;

  DashboardBloc(
      {required this.dashboardRepository,
      required this.dashboardRemoteDataSource})
      : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboardList);
    on<LoadAddProduct>(_onLoadAddProduct);
  }

  void _onLoadDashboardList(
      LoadDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    final failureOrSuccessOnline = await dashboardRepository.getListProduct();
    emit(
      failureOrSuccessOnline.fold(
        (failure) => DashboardFailure("Failed to load data"),
        (productModel) => DashboardLoaded(productModel),
      ),
    );
  }

  void _onLoadAddProduct(
      LoadAddProduct event, Emitter<DashboardState> emit) async {
    emit(AddProductLoading());

    try {
      final addProductModel = await dashboardRemoteDataSource.addProduct(
        event.title,
        event.brand,
        event.category,
        event.thumbnail,
      );
      emit(ProductAdded(addProductModel: addProductModel));
    } catch (e) {
      emit(ProductAddFailure('Failed to add product'));
    }
  }
}
