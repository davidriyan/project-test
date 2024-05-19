// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is AddProductLoading) {
            const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProductAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Sukses menambahkan produk'),
              ),
            );
            Navigator.pop(context);
            setState(() {});
          } else if (state is ProductAddFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan tittle';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: 'Brand'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan nama brand';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan jenis kategori';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _thumbnailController,
                  decoration: const InputDecoration(labelText: 'Thumbnail URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong masukkan url thumbnail';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<DashboardBloc>().add(LoadAddProduct(
                            title: _titleController.text,
                            brand: _brandController.text,
                            category: _categoryController.text,
                            thumbnail: _thumbnailController.text,
                          ));
                    }
                  },
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
