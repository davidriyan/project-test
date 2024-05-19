import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/product/data/models/product_detail_model.dart';
import 'package:flutter_application_1/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_application_1/features/product/presentation/pages/update_product_screen.dart';
import 'package:flutter_application_1/utils/colors.dart';
import 'package:flutter_application_1/utils/text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final int? id;
  const ProductDetailScreen({super.key, required this.id});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetailModel? productDetailModel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    if (widget.id != null) {
      BlocProvider.of<ProductBloc>(context).add(LoadProduct(id: widget.id!));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductLoading) {
            isLoading = true;
            const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
            setState(() {});
          } else if (state is ProductLoaded) {
            if (state.productDetailModel != null) {
              productDetailModel = state.productDetailModel;
            }
            isLoading = false;
          } else if (state is ProductFailure) {
            Text(state.error);
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    if (productDetailModel?.images != null &&
                        productDetailModel!.images!.isNotEmpty)
                      CarouselSlider(
                        options: CarouselOptions(
                          height: size.height * 0.3,
                          autoPlay: true,
                          aspectRatio: 2.0,
                        ),
                        items: productDetailModel!.images!
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  elevation: 4,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.greyColors,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(item),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    else
                      Center(
                        child: Text(
                          'Tunggu Sebentar Yaa...',
                          style: greyTextstyle.copyWith(
                            fontSize: 20,
                            fontWeight: bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 15),
                    Container(
                      height: size.height * 0.1,
                      width: size.width * 0.95,
                      decoration: BoxDecoration(
                        color: AppColors.greyColors,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (productDetailModel?.title != null &&
                              productDetailModel!.title!.isNotEmpty &&
                              productDetailModel?.price != null &&
                              productDetailModel?.rating != null)
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      productDetailModel?.title ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: whiteTextstyle.copyWith(
                                        fontSize: 17,
                                        fontWeight: medium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${productDetailModel?.price?.toString()}',
                                    style: whiteTextstyle.copyWith(
                                      fontSize: 18,
                                      fontWeight: medium,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber),
                                      const SizedBox(width: 5),
                                      Text(
                                        productDetailModel?.rating
                                                ?.toString() ??
                                            'Rating tidak tersedia',
                                        style: whiteTextstyle.copyWith(
                                          fontSize: 18,
                                          fontWeight: medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: size.height * 0.25,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        color: AppColors.greySecondColors,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              'Descriptions',
                              style: greyTextstyle.copyWith(
                                color: AppColors.greyColors,
                                fontSize: 20,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 20,
                              ),
                              child: Text(
                                productDetailModel?.description ?? '',
                                style: greyTextstyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: medium,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: size.height * 0.06,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.greyColors,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductUpdateScreen(
                                    id: productDetailModel!.id,
                                  );
                                },
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              'Update data',
                              textAlign: TextAlign.center,
                              style: whiteTextstyle.copyWith(
                                fontSize: 16,
                                fontWeight: medium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
