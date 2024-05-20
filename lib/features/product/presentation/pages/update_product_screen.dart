// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/product/data/models/product_update_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/product/presentation/bloc/product_bloc.dart';

class ProductUpdateScreen extends StatefulWidget {
  final int? id;
  const ProductUpdateScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ProductUpdateScreen> createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  late TextEditingController titleController;
  late TextEditingController brandController;

  ProductUpdateModel? productUpdateModel;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    brandController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up text editing controllers
    titleController.dispose();
    brandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Produk'),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductLoaded) {
            titleController.text = state.productDetailModel?.title ?? '';
            brandController.text = state.productDetailModel?.brand ?? '';
          } else if (state is ProductUpdateLoaded) {
            if (state.productUpdateModel != null) {
              productUpdateModel = state.productUpdateModel;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sukses melakukan update'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
            print(productUpdateModel!.title);
            print(productUpdateModel!.brand);
          } else if (state is ProductFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductUpdateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: brandController,
                    decoration: const InputDecoration(labelText: 'Brand'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(
                            LoadUpdateProduct(
                              id: widget.id!,
                              title: titleController.text,
                              brand: brandController.text,
                            ),
                          );
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
