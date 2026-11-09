
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_list_controller.dart';
import '../model/product_list_response.dart';

class EditProductScreen extends StatelessWidget {
  final ProductListResponse product;

  EditProductScreen({
    super.key,
    required this.product,
  });

  final ProductController controller = Get.find<ProductController>();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController =
  TextEditingController(text: product.title);

  late final TextEditingController priceController =
  TextEditingController(text: product.price.toString());

  late final TextEditingController descriptionController =
  TextEditingController(text: product.description);

  Future<void> updateProduct() async {
    if (!formKey.currentState!.validate()) return;

    await controller.updateExistingProduct(
      product.id!,
      {
        'title': titleController.text.trim(),
        'price': double.parse(priceController.text.trim()),
        'description': descriptionController.text.trim(),
      },
    );

    if (controller.errorMessage.value.isEmpty) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF252A5A);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Edit Product',
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF5F6FA),
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
              _buildField('Product Title', titleController),
              const SizedBox(height: 18),

              _buildField(
                'Price',
                priceController,
                isNumber: true,
              ),
              const SizedBox(height: 18),

              _buildField(
                'Description',
                descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 30),

              Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    'Update Product',
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

  Widget _buildField(
      String label,
      TextEditingController textController, {
        bool isNumber = false,
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textController,
          maxLines: maxLines,
          keyboardType: isNumber
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }

            if (isNumber) {
              final price = double.tryParse(value.trim());
              if (price == null || price <= 0) {
                return 'Enter a valid price';
              }
            }

            return null;
          },
        ),
      ],
    );
  }
}
