import 'package:get/get.dart';
import '../api_services/product_api_services.dart';
import '../model/category_response.dart';
import '../model/product_list_response.dart';

class ProductController extends GetxController {
  final ApiService apiService = ApiService();


  final RxList<ProductListResponse> products =
      <ProductListResponse>[].obs;
  final Rxn<ProductListResponse> singleProduct =
  Rxn<ProductListResponse>();
  final RxList<CategoryResponse> categoriess =
      <CategoryResponse>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = 'all'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSingleProductLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final int limit = 30;
  int skip = 0;
  final RxInt totalProducts = 0.obs;
  final RxBool hasMoreProducts = true.obs;
  final RxString selectedSort = 'default'.obs;
  final Rxn<DateTime> modifiedAfter = Rxn<DateTime>();
  final Rxn<DateTime> modifiedBefore = Rxn<DateTime>();
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
  }


  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      skip = 0;
      hasMoreProducts.value = true;

      final result = await apiService.getProducts(
        limit: limit,
        skip: skip,
      );

      products.assignAll(result.products);

      totalProducts.value = result.total;
      skip = result.products.length;
      hasMoreProducts.value = products.length < result.total;
    } catch (e) {
      products.clear();
      errorMessage.value = 'Unable to load products.';
      print('Fetch Products Error: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchSingleProduct(int productId) async {
    try {
      isSingleProductLoading.value = true;
      errorMessage.value = '';

      final result = await apiService.getProductById(productId);

      singleProduct.value = result;
    } catch (e) {
      singleProduct.value = null;
      errorMessage.value = 'Unable to load product details.';
      print('Single Product Error: $e');
    } finally {
      isSingleProductLoading.value = false;
    }
  }


  Future<void> fetchSearchProduct(String query) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (query.trim().isEmpty) {
        await fetchProducts();
        return;
      }

      final result = await apiService.searchProducts(
        query: query.trim(),
        limit: limit,
        skip: 0,
      );

      products.assignAll(result.products);

      totalProducts.value = result.total;
      skip = result.products.length;
      hasMoreProducts.value = products.length < result.total;
    } catch (e) {
      products.clear();
      errorMessage.value = 'Unable to search products.';
      print('Search Product Error: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> loadMoreProducts() async {
    if (isMoreLoading.value || !hasMoreProducts.value) {
      return;
    }

    try {
      isMoreLoading.value = true;

      final result = await apiService.getProducts(
        limit: limit,
        skip: skip,
      );

      products.addAll(result.products);

      skip += result.products.length;
      hasMoreProducts.value = products.length < result.total;
    } catch (e) {
      print('Load More Error: $e');
    } finally {
      isMoreLoading.value = false;
    }
  }


  Future<void> fetchCategories() async {
    try {
      final result = await apiService.getCategories();
      categoriess.assignAll(result);
    } catch (e) {
      print('Category Error: $e');
    }
  }
  String? getCategoryImage(String categorySlug) {
    final matchingProduct = products.firstWhereOrNull(
          (product) => product.category == categorySlug,
    );

    return matchingProduct?.thumbnail;
  }

  Future<void> fetchProductsByCategory(String category) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await apiService.getProductsByCategory(category);

      products.assignAll(result.products);
      totalProducts.value = result.total;
      skip = result.products.length;
      hasMoreProducts.value = products.length < result.total;
    } catch (e) {
      products.clear();
      errorMessage.value = 'Unable to load category products.';
      print('Category Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sortProducts({
    required String sortBy,
    required String order,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await apiService.getProducts(
        limit: limit,
        skip: 0,
        sortBy: sortBy,
        order: order,
      );

      products.assignAll(result.products);

      totalProducts.value = result.total;
      skip = result.products.length;
      hasMoreProducts.value = products.length < result.total;
    } catch (e) {
      errorMessage.value = 'Unable to sort products.';
      print('Sort Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> filterByModifiedDate() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await apiService.getProducts(
        limit: limit,
        skip: 0,
        modifiedAfter: modifiedAfter.value
            ?.toUtc()
            .toIso8601String(),
        modifiedBefore: modifiedBefore.value
            ?.toUtc()
            .toIso8601String(),
      );

      products.assignAll(result.products);

      totalProducts.value = result.total;
      skip = result.products.length;
      hasMoreProducts.value = products.length < result.total;

    } catch (e) {
      products.clear();
      errorMessage.value = 'Unable to filter products.';
      print('Date Filter Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNewProduct(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final newProduct = await apiService.addProduct(data);

      products.insert(0, newProduct);

    } catch (e) {
      errorMessage.value = e.toString();

      Get.snackbar(
        'Error',
        'Failed to add product',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> updateExistingProduct(
      int id,
      Map<String, dynamic> data,
      ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('UPDATE PRODUCT ID: $id');
      print('UPDATE PRODUCT DATA: $data');

      final updatedProduct = await apiService.updateProduct(id, data);




      final index = products.indexWhere(
            (product) => product.id == id,
      );

      if (index != -1) {
        products[index] = updatedProduct;
      }

      // Update details screen
      if (singleProduct.value?.id == id) {
        singleProduct.value = updatedProduct;
      }

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('UPDATE PRODUCT ERROR: $e');

      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> deleteExistingProduct(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('DELETE PRODUCT ID: $id');

      final result = await apiService.deleteProduct(id);

      print('DELETED PRODUCT: ${result['title']}');
      print('IS DELETED: ${result['isDeleted']}');
      print('DELETED ON: ${result['deletedOn']}');

      // Remove product from local list
      products.removeWhere((product) => product.id == id);

      // Clear details screen if it is the deleted product
      if (singleProduct.value?.id == id) {
        singleProduct.value = null;
      }

      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('DELETE PRODUCT ERROR: $e');

      return false;
    } finally {
      isLoading.value = false;
    }
  }


  void clearModifiedDateFilter() {
    modifiedAfter.value = null;
    modifiedBefore.value = null;

    fetchProducts();
  }

}
