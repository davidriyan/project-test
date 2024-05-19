// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison, avoid_print, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/dashboard/data/models/product_model.dart';
import 'package:flutter_application_1/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flutter_application_1/features/dashboard/presentation/pages/dashboard_add_product_screen.dart';
import 'package:flutter_application_1/features/product/presentation/pages/product_detail_screen.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ProductModel? productModel;
  List<Product> listProduct = [];
  List<Product> defaultListProduct = [];
  bool isLoading = false;
  bool isSearching = false;
  int _visibleThreshold = 10;
  int _scrolledItemCount = 0;

  final ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
    getData();
  }

  int calculateItemCount() {
    int itemCount = listProduct.length;
    if (isLoading) {
      itemCount += 1;
    }
    if (_scrolledItemCount >= _visibleThreshold) {
      itemCount += 1;
    }
    return itemCount;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void getData() {
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    if (dashboardBloc != null) {
      dashboardBloc.add(LoadDashboard());
    }
  }

  void clearData() {
    listProduct = [];
    defaultListProduct = [];
    setState(() {});
  }

  void onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      int lastVisibleItemIndex =
          scrollController.position.pixels ~/ _visibleThreshold;
      if (lastVisibleItemIndex % _visibleThreshold == 0) {
        loadListData();
      }
    }
  }

  void loadListData() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      getData();
    }
  }

  void filterSearch(String query) {
    if (query == '') {
      listProduct = [];
    } else {
      listProduct = defaultListProduct
          .where((e) => e.brand!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: !isSearching ? const Text('Dashboard') : const SizedBox.shrink(),
        actions: [
          !isSearching
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        isSearching = true;
                        listProduct = [];
                        setState(() {});
                      },
                      icon: const Icon(Icons.search),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddProductScreen();
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                )
              : const SizedBox.shrink()
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25),
          child: isSearching
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    bottom: 15,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          if (isSearching) {
                            isSearching = false;
                            searchController.text = '';
                            listProduct = defaultListProduct;
                          } else {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          }
                          setState(() {});
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                      const SizedBox(
                        width: 17,
                      ),
                      Container(
                        width: size.width * 0.77,
                        height: size.height * 0.065,
                        padding: const EdgeInsets.only(left: 20),
                        decoration: const BoxDecoration(
                          color: AppColors.greySecondColors,
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Icon(Icons.search),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width: size.width * 0.58,
                              child: TextFormField(
                                controller: searchController,
                                onChanged: (value) {
                                  filterSearch(value);
                                  setState(() {});
                                },
                                style: greyTextstyle.copyWith(
                                  fontSize: 13,
                                  fontWeight: bold,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Cari brand idaman Anda...",
                                  hintStyle: greyTextstyle.copyWith(
                                    fontSize: 12,
                                  ),
                                  suffixIcon: searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            searchController.clear();
                                            isSearching = false;
                                            listProduct = defaultListProduct;
                                            setState(() {});
                                          },
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardLoading) {
            isLoading = true;
            setState(() {});
          } else if (state is DashboardLoaded) {
            if (state.productModel != null) {
              productModel = state.productModel;
              listProduct = productModel!.products!;
              defaultListProduct = productModel!.products!;
              print(productModel!.products!.first.category!);
              print(productModel!.products!.first.id!);
            }
            isLoading = false;
            setState(() {});
          }
        },
        builder: (context, state) {
          return ListView.builder(
            controller: scrollController,
            itemCount: calculateItemCount(),
            itemBuilder: (context, index) {
              if (index == listProduct.length) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var product = listProduct[index];
              return Container(
                margin: const EdgeInsets.all(20),
                height: size.height * 0.45,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.brand ?? '',
                            style: whiteTextstyle.copyWith(
                              fontSize: 18,
                              fontWeight: bold,
                            ),
                          ),
                          Text(
                            product.category ?? '',
                            style: whiteTextstyle.copyWith(
                              fontSize: 10,
                              fontWeight: bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        width: size.width,
                        height: size.height * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          image: DecorationImage(
                            image: NetworkImage(product.thumbnail ?? ''),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '\$${product.price.toString()}',
                          style: whiteTextstyle.copyWith(
                            fontSize: 15,
                            fontWeight: medium,
                          ),
                        ),
                        Text(
                          product.brand ?? '',
                          style: whiteTextstyle.copyWith(
                            fontSize: 15,
                            fontWeight: medium,
                          ),
                        ),
                        Text(
                          product.rating.toString(),
                          style: whiteTextstyle.copyWith(
                            fontSize: 15,
                            fontWeight: medium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 6,
                        child: Container(
                          height: size.height * 0.05,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.whiteColors,
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: AppColors.greySecondColors,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductDetailScreen(
                                        id: product.id,
                                      );
                                    },
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Text(
                                  'Detail',
                                  textAlign: TextAlign.center,
                                  style: greyTextstyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
