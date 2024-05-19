class AddProductModel {
  final String title;
  final String brand;
  final String category;
  final String thumbnail;

  AddProductModel(
      {required this.title,
      required this.brand,
      required this.category,
      required this.thumbnail});

  factory AddProductModel.fromJson(Map<String, dynamic> json) {
    return AddProductModel(
      title: json['title'],
      brand: json['brand'],
      category: json['category'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
    };
  }
}
