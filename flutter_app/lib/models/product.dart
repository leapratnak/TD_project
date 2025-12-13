class Product {
  final int id;
  final String name;
  final String description;
  final int? categoryId;
  final String? categoryName;
  final double price;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    this.categoryId,
    this.categoryName,
    required this.price,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['Id'] ?? j['id'],
    name: j['Name'] ?? j['name'],
    description: j['Description'] ?? j['description'] ?? '',
    categoryId: j['CategoryId'] ?? j['categoryId'],
    categoryName: j['CategoryName'] ?? j['categoryName'],
    price: (j['Price'] is num) ? (j['Price'] as num).toDouble() : double.tryParse('${j['Price']}') ?? 0.0,
    imageUrl: j['ImageUrl'] ?? j['imageUrl'],
  );
}
