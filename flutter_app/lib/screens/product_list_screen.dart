import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/category.dart';
import '../models/debouncer.dart';
import '../services/product_service.dart';
import '../services/category_service.dart';
import '../screens/dialog/product_dialog.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService productService = ProductService();
  final CategoryService categoryService = CategoryService();
  final Debouncer debouncer = Debouncer(milliseconds: 500);

  List<Product> products = [];
  List<Category> categories = [];

  int page = 1;
  final int limit = 20;
  int totalPages = 1;
  bool loading = false;

  String search = '';
  String sortBy = 'id';
  String sortOrder = 'desc';
  int? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
  }

  /* =======================
     LOAD DATA
  ======================== */
  Future<void> _loadCategories() async {
    try {
      categories = await categoryService.getAllCategories();
      setState(() {});
    } catch (e) {
      debugPrint('Load categories error: $e');
    }
  }

  Future<void> _loadProducts({int pageNumber = 1}) async {
    setState(() => loading = true);
    page = pageNumber;

    try {
      final result = await productService.getProducts(
        search: search,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        categoryId: selectedCategory,
      );

      products = result['products'];
      totalPages = result['meta']['pages'];

      // Ensure full URL for images
      products = products.map((p) {
        if (p.imageUrl != null &&
            p.imageUrl!.isNotEmpty &&
            !p.imageUrl!.startsWith('http')) {
          return Product(
            id: p.id,
            name: p.name,
            description: p.description,
            price: p.price,
            categoryId: p.categoryId,
            categoryName: p.categoryName,
            imageUrl: 'http://192.168.56.1:3000${p.imageUrl}',
          );
        }
        return p;
      }).toList();
    } catch (e) {
      debugPrint('Load products error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  /* =======================
     CREATE / UPDATE
  ======================== */
  void _openCreateDialog() {
    showDialog(
      context: context,
      builder: (_) => ProductDialog(
        categories: categories,
        onSave:
            (
              String name,
              String desc,
              double price,
              int catId,
              File? imageFile,
              Uint8List? webImageBytes,
            ) async {
              await productService.createProduct(
                name: name,
                description: desc,
                price: price,
                categoryId: catId,
                imageFile: imageFile,
                webImageBytes: webImageBytes,
              );
              _loadProducts(pageNumber: 1);
            },
      ),
    );
  }

  void _openEditDialog(Product p) {
    showDialog(
      context: context,
      builder: (_) => ProductDialog(
        product: p,
        categories: categories,
        onSave:
            (
              String name,
              String desc,
              double price,
              int catId,
              File? imageFile,
              Uint8List? webImageBytes,
            ) async {
              await productService.updateProduct(
                id: p.id,
                name: name,
                description: desc,
                price: price,
                categoryId: catId,
                imageFile: imageFile,
                webImageBytes: webImageBytes,
              );
              _loadProducts(pageNumber: page);
            },
      ),
    );
  }

  Future<void> _deleteProduct(int id) async {
    await productService.deleteProduct(id);
    _loadProducts(pageNumber: page);
  }

  /* =======================
     UI WIDGETS
  ======================== */
  Widget _buildProductTile(Product p) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: p.imageUrl != null && p.imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: p.imageUrl!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (_, __) => const SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 50),
              )
            : const Icon(Icons.image, size: 50),
        title: Text(p.name),
        subtitle: Text(
          '${p.categoryName ?? ''} • \$${p.price.toStringAsFixed(2)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _openEditDialog(p),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteProduct(p.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(totalPages, (i) {
          final p = i + 1;
          return InkWell(
            onTap: () => _loadProducts(pageNumber: p),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: p == page ? Colors.deepPurple : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$p',
                style: TextStyle(
                  color: p == page ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /* =======================
     BUILD
  ======================== */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.deepPurple,
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              setState(() {
                if (sortBy == v) {
                  sortOrder = sortOrder == 'asc' ? 'desc' : 'asc';
                } else {
                  sortBy = v;
                  sortOrder = 'asc';
                }
              });
              _loadProducts(pageNumber: 1);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'name', child: Text('Sort by Name')),
              PopupMenuItem(value: 'price', child: Text('Sort by Price')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (v) {
                      debouncer.run(() {
                        search = v;
                        _loadProducts(pageNumber: 1);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search product",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<int?>(
                    value: selectedCategory,
                    items: [
                      const DropdownMenuItem(value: null, child: Text("All")),
                      ...categories.map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ),
                    ],
                    onChanged: (v) {
                      selectedCategory = v;
                      _loadProducts(pageNumber: 1);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? const Center(child: Text("No products found"))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (_, i) => _buildProductTile(products[i]),
                  ),
          ),
          if (!loading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildPagination(),
            ),
        ],
      ),
    );
  }
}
