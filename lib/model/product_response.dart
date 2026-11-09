
import 'package:shoppyy/model/product_list_response.dart';

class ProductsResponse {
  final List<ProductListResponse> products;
  final int total;
  final int skip;
  final int limit;

  ProductsResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      products: (json['products'] as List? ?? [])
          .map(
            (e) => ProductListResponse.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}
