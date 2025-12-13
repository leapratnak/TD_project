import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  final String baseUrl = "http://192.168.56.1:3000/api/categories";

  Future<List<Category>> getCategories(String search) async {
    final res = await http.get(
      Uri.parse("$baseUrl?search=${Uri.encodeQueryComponent(search)}"),
      headers: {"Accept": "application/json"},
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List data = json['data'] ?? [];
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      print("API Error: ${res.body}");
      throw Exception("Failed to fetch categories");
    }
  }

  Future<List<Category>> getAllCategories() async {
    final res = await http.get(Uri.parse(baseUrl), headers: {'Accept': 'application/json'});
    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List data = json['data'] ?? [];
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories: ${res.body}');
    }
  }

  Future<bool> createCategory(String name, String description) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "description": description}),
    );
    return res.statusCode == 201;
  }

  Future<bool> updateCategory(int id, String name, String description) async {
    final res = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "description": description}),
    );
    return res.statusCode == 200;
  }

  Future<bool> deleteCategory(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    return res.statusCode == 200;
  }
}
