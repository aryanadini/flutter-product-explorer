
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_list_controller.dart';
import 'edit_product_view.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final ProductController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<ProductController>();

    // API call happens once when the screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      controller.fetchSingleProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
          actions: [
            Obx(() {
              final product = controller.singleProduct.value;

              if (product == null) {
                return const SizedBox.shrink();
              }

              return IconButton(
                onPressed: () {
                  Get.to(
                        () => EditProductScreen(
                      product: product,
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Product',
              );
            }),
            IconButton(
              onPressed: () {
                final product = controller.singleProduct.value;

                if (product == null) return;

                Get.defaultDialog(
                  title: 'Delete Product',
                  middleText: 'Are you sure you want to delete this product?',
                  textCancel: 'Cancel',
                  textConfirm: 'Delete',
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    Get.back();

                    final success = await controller.deleteExistingProduct(
                      product.id!,
                    );

                    if (success) {
                      Get.snackbar(
                        'Success',
                        'Product deleted successfully!',
                        snackPosition: SnackPosition.BOTTOM,
                      );

                      Get.back();
                    } else {
                      Get.snackbar(
                        'Error',
                        'Failed to delete product: ${controller.errorMessage.value}',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                );
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              tooltip: 'Delete Product',
            ),
          ],
        ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final product = controller.singleProduct.value;

        if (product == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Product not found'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    controller.fetchSingleProduct(widget.productId);
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.thumbnail,
                height: 250,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 250,
                    child: Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(product.description),

              const SizedBox(height: 15),

              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text('Category: ${product.category}'),
              Text('Brand: ${product.brand ?? "N/A"}'),
              Row(
                children: [
                  Text('Rating: ${product.rating} '),
                  Icon(Icons.star,color: Colors.amber,)
                ],
              ),
              Text('Stock: ${product.stock}'),
            ],
          ),
        );
      }),
    );
  }
}
