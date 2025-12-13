class Category {
  final int id;
  final String name;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['Id'],               // match backend column
      name: json['Name'],
      description: json['Description'] ?? "",
    );
  }
}
