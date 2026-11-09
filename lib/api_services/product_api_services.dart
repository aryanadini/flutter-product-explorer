
import 'package:dio/dio.dart';
import '../model/category_response.dart';
import '../model/product_list_response.dart';
import '../model/product_response.dart';

class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  //Get all products with pagination and sorting
  Future<ProductsResponse> getProducts({
    int limit = 30,
    int skip = 0,
    String? sortBy,
    String? order,
    String? modifiedAfter,
    String? modifiedBefore,
    String? select,
  }) async {
    final response = await dio.get(
      '/products',
      queryParameters: {
        'limit': limit,
        'skip': skip,
        if (sortBy != null) 'sortBy': sortBy,
        if (order != null) 'order': order,
        if (modifiedAfter != null) 'modifiedAfter': modifiedAfter,
        if (modifiedBefore != null) 'modifiedBefore': modifiedBefore,
        if (select != null) 'select': select,
      },
    );

    return ProductsResponse.fromJson(response.data);
  }

  //Get a single product
  Future<ProductListResponse> getProductById(int id) async {
    final response = await dio.get('/products/$id');

    return ProductListResponse.fromJson(response.data);
  }

  //Search products
  Future<ProductsResponse> searchProducts({
    required String query,
    int limit = 30,
    int skip = 0,
  }) async {
    final response = await dio.get(
      '/products/search',
      queryParameters: {
        'q': query,
        'limit': limit,
        'skip': skip,
      },
    );

    return ProductsResponse.fromJson(response.data);
  }

  //Get all products in a category
  Future<ProductsResponse> getProductsByCategory(
      String category,
      ) async {
    final response = await dio.get(
      '/products/category/$category',
    );

    return ProductsResponse.fromJson(response.data);
  }

  //Get category names
  Future<List<String>> getCategoryList() async {
    final response = await dio.get('/products/category-list');

    return List<String>.from(response.data);
  }

  //Get category details
  Future<List<CategoryResponse>> getCategories() async {
    try {
      final response = await dio.get('/products/categories');

      return (response.data as List)
          .map((item) => CategoryResponse.fromJson(item))
          .toList();
    } catch (e) {
      print('Get Categories Error: $e');
      rethrow;
    }
  }

  // Add a product
  Future<ProductListResponse> addProduct(
      Map<String, dynamic> data,
      ) async {
    final response = await dio.post(
      '/products/add',
      data: data,
    );

    return ProductListResponse.fromJson(response.data);
  }


  //  Update a product
  Future<ProductListResponse> updateProduct(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await dio.patch(
      '/products/$id',
      data: data,
    );

    print('UPDATE API STATUS: ${response.statusCode}');
    print('UPDATE API RESPONSE: ${response.data}');

    return ProductListResponse.fromJson(response.data);
  }

  // Delete a product
  Future<Map<String, dynamic>> deleteProduct(int id) async {
    final response = await dio.delete('/products/$id');

    return Map<String, dynamic>.from(response.data);
  }


}
