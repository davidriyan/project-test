// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:flutter_application_1/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/service_locator.dart' as service_locator;
import 'package:flutter_application_1/features/dashboard/presentation/bloc/dashboard_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Hive
  await Hive.initFlutter();
  // Buka box yang diperlukan
  await Hive.openBox('product');

  // Inisialisasi service locator
  await service_locator.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => service_locator.sl<DashboardBloc>(),
        ),
        BlocProvider(
          create: (_) => service_locator.sl<ProductBloc>(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DashboardScreen(),
      ),
    );
  }
}
