import 'package:dio/dio.dart';
import '../models/article_model.dart';

class NewsService {
  final Dio _dio = Dio();
  final String _apiKey = 'pub_827737d258d34e6593bd86cd76768c96';
  final String _baseUrl = 'https://newsdata.io/api/1/news';

  Future<List<Article>> fetchNews({
    String country = 'eg',
    String? keyword,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'apikey': _apiKey,
          'country': country,
          'language': 'ar',
          if (keyword != null && keyword.isNotEmpty) 'q': keyword,
        },
      );

      List results = response.data['results'];
      return results.map((json) => Article.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error fetching news: $e');
      return [];
    }
  }
}
