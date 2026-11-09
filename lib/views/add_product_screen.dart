
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_list_controller.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductController controller = Get.find<ProductController>();
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  final List<String> categories = [
    'beauty',
    'fragrances',
    'furniture',
    'groceries',
    'home-decoration',
    'kitchen-accessories',
    'laptops',
    'mens-shirts',
    'mens-shoes',
    'mens-watches',
    'mobile-accessories',
    'motorcycle',
    'skin-care',
    'smartphones',
    'sports-accessories',
    'sunglasses',
    'tablets',
    'tops',
    'vehicle',
    'womens-bags',
    'womens-dresses',
    'womens-jewellery',
    'womens-shoes',
    'womens-watches',
  ];

  String selectedCategory = 'beauty';

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> submitProduct() async {
    if (!formKey.currentState!.validate()) return;

    await controller.addNewProduct({
      'title': titleController.text.trim(),
      'price': double.parse(priceController.text.trim()),
      'description': descriptionController.text.trim(),
      'category': selectedCategory,
    });

    // Check whether the API request was successful
    if (controller.errorMessage.value.isEmpty && mounted) {
      // Clear all text fields
      titleController.clear();
      priceController.clear();
      descriptionController.clear();

      // Reset category
      setState(() {
        selectedCategory = 'beauty';
      });

      // Reset form validation messages
      formKey.currentState?.reset();

      Get.snackbar(
        'Success',
        'Product added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF252A5A);
    const background = Color(0xFFF5F6FA);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: background,
        elevation: 0,
        iconTheme: const IconThemeData(color: navy),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enter the details of your new product.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),

              _buildLabel('Product Title'),
              _buildTextField(
                controller: titleController,
                hint: 'Enter product name',
                icon: Icons.shopping_bag_outlined,
              ),

              const SizedBox(height: 18),
              _buildLabel('Price'),
              _buildTextField(
                controller: priceController,
                hint: 'Enter product price',
                icon: Icons.currency_rupee,
                isNumber: true,
              ),

              const SizedBox(height: 18),
              _buildLabel('Description'),
              _buildTextField(
                controller: descriptionController,
                hint: 'Enter product description',
                icon: Icons.description_outlined,
                maxLines: 4,
              ),

              const SizedBox(height: 18),
              _buildLabel('Category'),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                isExpanded: true,
                decoration: _inputDecoration(
                  'Select category',
                  Icons.category_outlined,
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category.replaceAll('-', ' ').capitalize!,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 30),

              Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : submitProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: _inputDecoration(hint, icon),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }

        if (isNumber) {
          final price = double.tryParse(value.trim());
          if (price == null || price <= 0) {
            return 'Enter a valid price greater than zero';
          }
        }

        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF252A5A)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF252A5A),
        ),
      ),
    );
  }
}
