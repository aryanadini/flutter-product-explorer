class CategoryResponse {
  final String slug;
  final String name;
  final String url;

  CategoryResponse({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}