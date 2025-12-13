import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/product.dart';
import '../../models/category.dart';

class ProductDialog extends StatefulWidget {
  final Product? product;
  final List<Category> categories;
  final Function(
    String name,
    String desc,
    double price,
    int catId,
    File? imageFile,
    Uint8List? webImageBytes,
  ) onSave;

  const ProductDialog({
    Key? key,
    this.product,
    required this.categories,
    required this.onSave,
  }) : super(key: key);

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final ImagePicker picker = ImagePicker();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();

  int? selectedCategory;
  File? pickedFile;
  Uint8List? pickedWebImage;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      nameCtrl.text = widget.product!.name;
      descCtrl.text = widget.product!.description;
      priceCtrl.text = widget.product!.price.toString();
      selectedCategory = widget.product!.categoryId;
    }
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) pickedWebImage = await image.readAsBytes();
    } else {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) pickedFile = File(image.path);
    }
    setState(() {});
  }

  Widget _imagePreview() {
    if (pickedFile != null) {
      return Image.file(
        pickedFile!,
        height: 120,
        width: 120,
        fit: BoxFit.cover,
      );
    } else if (pickedWebImage != null) {
      return Image.memory(
        pickedWebImage!,
        height: 120,
        width: 120,
        fit: BoxFit.cover,
      );
    } else if (widget.product?.imageUrl != null && widget.product!.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.product!.imageUrl!,
        height: 120,
        width: 120,
        fit: BoxFit.cover,
        placeholder: (_, __) => const SizedBox(
          width: 120,
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
      );
    } else {
      return const Icon(Icons.image, size: 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? "Create Product" : "Edit Product"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _imagePreview(),
            TextButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.upload),
              label: const Text("Upload Image"),
            ),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            DropdownButtonFormField<int>(
              value: selectedCategory,
              decoration: const InputDecoration(labelText: "Category"),
              items: widget.categories
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (v) => setState(() => selectedCategory = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          child: const Text("Save"),
          onPressed: () {
            if (selectedCategory == null) selectedCategory = 0;
            widget.onSave(
              nameCtrl.text.trim(),
              descCtrl.text.trim(),
              double.tryParse(priceCtrl.text.trim()) ?? 0.0,
              selectedCategory!,
              pickedFile,
              pickedWebImage,
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
