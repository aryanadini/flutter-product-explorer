
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppyy/views/product_details_view.dart';
import '../controllers/product_list_controller.dart';
import '../model/product_list_response.dart';
import '../widget/categories.dart';
import '../widget/colors.dart';
import 'add_product_screen.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_list_controller.dart';
import '../model/product_list_response.dart';
import '../widget/colors.dart';
import '../widget/categories.dart';
import 'product_details_view.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_list_controller.dart';
import '../model/product_list_response.dart';
import '../widget/colors.dart';
import '../widget/categories.dart';

import 'product_details_view.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  final ProductController controller = Get.put(ProductController());

  final ScrollController scrollController = ScrollController();

  final TextEditingController searchController = TextEditingController();

  void setupPagination() {
    if (scrollController.hasListeners) return;

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupPagination();

    return Scaffold(
      backgroundColor: AppColors.background,

      // APP BAR
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Shoppyy',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_bag_rounded,
              color: AppColors.shoppingBag,
              size: 27,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ADD PRODUCT BUTTON
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddProductScreen());
        },
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),

      // BODY
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => controller.fetchProducts(),
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    const Text(
                      'Discover Products',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Find your favourite products',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SEARCH
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          controller.fetchSearchProduct(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          hintStyle: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.primary,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();
                              controller.fetchProducts();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.grey,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // CATEGORIES HEADING
                    const Text(
                      'Categories',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // CATEGORIES
                    Obx(() {
                      return SizedBox(
                        height: 105,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            buildCategoryItem(
                              name: 'All',
                              image: null,
                              isSelected:
                              controller.selectedCategory.value == 'all',
                              onTap: () {
                                controller.selectedCategory.value = 'all';
                                controller.fetchProducts();
                              },
                            ),

                            ...controller.categoriess.map((category) {
                              return buildCategoryItem(
                                name: category.name ?? '',
                                image: controller.getCategoryImage(
                                  category.slug ?? '',
                                ),
                                isSelected:
                                controller.selectedCategory.value ==
                                    category.slug,
                                onTap: () {
                                  controller.selectedCategory.value =
                                      category.slug ?? '';

                                  controller.fetchProductsByCategory(
                                    category.slug ?? '',
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 22),

                    // PRODUCT HEADING AND SORT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Popular Products',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Obx(() {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.navy,
                                width: 1.3,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.selectedSort.value,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.navy,
                                ),
                                dropdownColor: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                style: const TextStyle(
                                  color: AppColors.navy,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'default',
                                    child: Text('Default'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'price_asc',
                                    child: Text('Price: Low to High'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'price_desc',
                                    child: Text('Price: High to Low'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'rating',
                                    child: Text('Top Rated'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == null) return;

                                  controller.selectedSort.value = value;

                                  if (value == 'price_asc') {
                                    controller.sortProducts(
                                      sortBy: 'price',
                                      order: 'asc',
                                    );
                                  } else if (value == 'price_desc') {
                                    controller.sortProducts(
                                      sortBy: 'price',
                                      order: 'desc',
                                    );
                                  } else if (value == 'rating') {
                                    controller.sortProducts(
                                      sortBy: 'rating',
                                      order: 'desc',
                                    );
                                  } else {
                                    controller.fetchProducts();
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),

            // PRODUCT GRID
            Obx(() {
              if (controller.isLoading.value &&
                  controller.products.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                );
              }

              if (controller.errorMessage.isNotEmpty &&
                  controller.products.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 45,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Something went wrong!',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => controller.fetchProducts(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.products.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final product = controller.products[index];

                      return ProductCard(product: product);
                    },
                    childCount: controller.products.length,
                  ),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.62,
                  ),
                ),
              );
            }),

            // PAGINATION LOADER
            Obx(() {
              if (!controller.isMoreLoading.value) {
                return const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                );
              }

              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            }),

            // BOTTOM SPACING
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }
}

// PRODUCT CARD
class ProductCard extends StatelessWidget {
  final ProductListResponse product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
              () => ProductDetailsScreen(productId: product.id!),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRODUCT IMAGE
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: AppColors.primaryLight,
                      child: Image.network(
                        product.thumbnail ?? '',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.grey,
                              size: 35,
                            ),
                          );
                        },
                      ),
                    ),
                  ),


                ],
              ),
            ),

            // PRODUCT INFORMATION
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.pink,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      product.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    // RATING
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.rating,
                          size: 16,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${product.rating ?? 0}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // PRICE
                    Text(
                      '\$${product.price ?? 0}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






