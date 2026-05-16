import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const _baseUrl = 'https://dummyjson.com';

  /// Ambil semua produk (limit 100)
  static Future<List<Product>> getProducts() async {
    final uri = Uri.parse('$_baseUrl/products?limit=100');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final products = data['products'] as List;
      return products
          .map((p) => Product.fromJson(p as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Gagal memuat produk: ${response.statusCode}');
  }

  /// Ambil detail produk berdasarkan ID
  static Future<Product> getProductDetail(int id) async {
    final uri = Uri.parse('$_baseUrl/products/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Product.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Gagal memuat detail produk: ${response.statusCode}');
  }
}
