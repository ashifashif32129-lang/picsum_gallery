
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/picsum_image.dart';

class PicsumService {
  static const String baseUrl =
      'https://dummyjson.com/products';

  Future<List<PicsumImage>> fetchImages({
    int skip = 0,
    int limit = 20,
  }) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'limit': limit.toString(),
        'skip': skip.toString(),
      },
    );

    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List products = data['products'];

      return products
          .map((item) => PicsumImage.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to fetch images');
    }
  }
}
