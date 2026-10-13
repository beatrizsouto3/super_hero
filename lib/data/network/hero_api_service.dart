import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:super_hero/data/models/hero_model.dart';

class HeroApiService {
  HeroApiService({required this.baseUrl, Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: requestTimeout,
              receiveTimeout: requestTimeout,
              sendTimeout: requestTimeout,
              responseType: ResponseType.json,
            ),
          );

  final String baseUrl;
  final Dio _dio;
  static const Duration requestTimeout = Duration(seconds: 10);

  Future<List<HeroModel>> fetchHeroes({
    int page = 1,
    int limit = 1000,
    String query = '',
  }) async {
    final queryParameters = <String, String>{
      '_page': '$page',
      '_limit': '$limit',
    };
    if (query.trim().isNotEmpty) {
      queryParameters['name_like'] = query.trim();
    }
    final uri = _heroesUri(queryParameters: queryParameters);
    final response = await _dio.getUri<dynamic>(uri);

    final decoded = _decodeResponse(response.data);
    if (decoded is! List) {
      throw const FormatException('A API não retornou uma lista de heróis.');
    }

    return decoded
        .map(
          (item) => HeroModel.fromJson(
            Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
          ),
        )
        .toList();
  }

  Future<HeroModel> fetchHeroById(int id) async {
    final uri = _heroesUri(pathSuffix: '/$id');
    final response = await _dio.getUri<dynamic>(uri);

    final decoded = _decodeResponse(response.data);
    if (decoded is! Map) {
      throw const FormatException('A API não retornou um herói.');
    }

    return HeroModel.fromJson(Map<String, dynamic>.from(decoded));
  }

  void dispose() => _dio.close(force: true);

  dynamic _decodeResponse(dynamic data) =>
      data is String ? jsonDecode(data) : data;

  Uri _heroesUri({
    String pathSuffix = '',
    Map<String, String>? queryParameters,
  }) {
    final normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$normalizedBaseUrl/heroes$pathSuffix')
        .replace(queryParameters: queryParameters);
  }
}
