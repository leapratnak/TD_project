import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import '../models/debouncer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryService service = CategoryService();
  final Debouncer debouncer = Debouncer(milliseconds: 500);

  List<Category> categories = [];
  String searchText = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    setState(() => loading = true);
    try {
      final data = await service.getCategories(searchText);
      setState(() => categories = data);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to load categories")));
    } finally {
      setState(() => loading = false);
    }
  }

  void openCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(
        onSave: (name, description) async {
          final success = await service.createCategory(name, description);
          if (success) loadCategories();
        },
      ),
    );
  }

  void openEditDialog(Category category) {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(
        category: category,
        onSave: (name, description) async {
          final success = await service.updateCategory(category.id, name, description);
          if (success) loadCategories();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Management"),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCreateDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search category (Khmer/English)",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                searchText = value;
                debouncer.run(() {
                  loadCategories();
                });
              },
            ),
          ),

          // Category list
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : categories.isEmpty
                    ? const Center(child: Text("No categories found"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final c = categories[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            child: ListTile(
                              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(c.description),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => openEditDialog(c),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text("Delete Category"),
                                          content: const Text("Are you sure you want to delete this category?"),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                                            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
                                          ],
                                        ),
                                      );
                                      if (confirmed == true) {
                                        final success = await service.deleteCategory(c.id);
                                        if (success) loadCategories();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class CategoryDialog extends StatefulWidget {
  final Category? category;
  final Function(String, String) onSave;

  const CategoryDialog({Key? key, this.category, required this.onSave}) : super(key: key);

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      nameCtrl.text = widget.category!.name;
      descCtrl.text = widget.category!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(widget.category == null ? "Create Category" : "Edit Category"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descCtrl,
            decoration: const InputDecoration(labelText: "Description"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            final name = nameCtrl.text.trim();
            final desc = descCtrl.text.trim();
            if (name.isEmpty) return;
            widget.onSave(name, desc);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
