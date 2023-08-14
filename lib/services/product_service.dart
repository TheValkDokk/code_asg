import 'package:code_asg/constain.dart';
import 'package:code_asg/models/product.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  final Dio _dio = Dio();
  final String _api = dotenv.env['PRODUCT_API'].toString();

  Future<List<Product>> _parseProductsResponse(Response response) async {
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> productJsonList = data['products'] as List<dynamic>;

      return productJsonList.map((productJson) {
        return Product.fromJson(productJson as Map<String, dynamic>);
      }).toList();
    } else if (response.statusCode == 404) {
      throw Exception("Resource not found");
    } else {
      throw Exception("An error occurred while fetching data");
    }
  }

  Future<List<Product>> fetchProduct(int page) async {
    // Load products with pagination
    const double limit = productLoad;
    final double skip = page * limit;

    try {
      final response = await _dio.get(
        _api,
        queryParameters: {'limit': limit, 'skip': skip},
      );

      return _parseProductsResponse(response);
    } catch (e) {
      throw Exception("An error occurred while fetching data: $e");
    }
  }

  Future<List<Product>> fetchProductWithSearch(String search) async {
    // Load products with search
    try {
      final response = await _dio.get(
        "$_api/search",
        queryParameters: {'q': search},
      );

      return _parseProductsResponse(response);
    } catch (e) {
      throw Exception("An error occurred while fetching data: $e");
    }
  }
}
