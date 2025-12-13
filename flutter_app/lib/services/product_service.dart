import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/product.dart';

class ProductService {
  final String baseUrl = 'http://192.168.56.1:3000/api/products'; // Your PC IP

  Future<Map<String, dynamic>> getProducts({
    String search = '',
    int page = 1,
    int limit = 20,
    String sortBy = 'id',
    String sortOrder = 'desc',
    int? categoryId,
  }) async {
    final params = <String, String>{
      'search': search,
      'page': page.toString(),
      'limit': limit.toString(),
      'sort_by': sortBy,
      'sort_order': sortOrder,
    };
    if (categoryId != null) params['category_id'] = categoryId.toString();

    final uri = Uri.parse(baseUrl).replace(queryParameters: params);
    print('GET Products URL: $uri');

    final res = await http.get(uri);
    print('GET Response: ${res.statusCode} ${res.body}');

    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List data = json['data'] ?? [];
      final products = data.map((e) => Product.fromJson(e)).toList();
      print('Parsed ${products.length} products');
      return {
        'products': products,
        'meta': json['meta'],
      };
    } else {
      throw Exception('Failed to load products: ${res.body}');
    }
  }

  Future<bool> createProduct({
    required String name,
    String? description,
    required double price,
    int? categoryId,
    File? imageFile,
    Uint8List? webImageBytes,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.fields['name'] = name;
      request.fields['price'] = price.toString();
      if (description != null) request.fields['description'] = description;
      if (categoryId != null) request.fields['categoryId'] = categoryId.toString();

      if (kIsWeb && webImageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          webImageBytes,
          filename: 'web_image_${DateTime.now().millisecondsSinceEpoch}.png',
          contentType: MediaType('image', 'png'),
        ));
      } else if (!kIsWeb && imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      print('CREATE Response: ${response.statusCode} $respStr');
      return response.statusCode == 201;
    } catch (e) {
      print('createProduct error: $e');
      return false;
    }
  }

  Future<bool> updateProduct({
    required int id,
    String? name,
    String? description,
    double? price,
    int? categoryId,
    File? imageFile,
    Uint8List? webImageBytes, File? imageUrl,
  }) async {
    try {
      final request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$id'));
      if (name != null) request.fields['name'] = name;
      if (description != null) request.fields['description'] = description;
      if (price != null) request.fields['price'] = price.toString();
      if (categoryId != null) request.fields['categoryId'] = categoryId.toString();

      if (kIsWeb && webImageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          webImageBytes,
          filename: 'web_image_${DateTime.now().millisecondsSinceEpoch}.png',
          contentType: MediaType('image', 'png'),
        ));
      } else if (!kIsWeb && imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      print('UPDATE Response: ${response.statusCode} $respStr');
      return response.statusCode == 200;
    } catch (e) {
      print('updateProduct error: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));
      print('DELETE Response: ${res.statusCode} ${res.body}');
      return res.statusCode == 200;
    } catch (e) {
      print('deleteProduct error: $e');
      return false;
    }
  }
}
