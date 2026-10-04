import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/hero_model.dart';

class HeroApiService {
  HeroApiService({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<List<HeroModel>> fetchHeroes({int page = 1, int limit = 1000}) async {
    final uri = _heroesUri(
      queryParameters: <String, String>{'_page': '$page', '_limit': '$limit'},
    );
    final response = await _client.get(uri);

    _ensureSuccess(response, uri);
    final decoded = jsonDecode(response.body);
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
    final response = await _client.get(uri);

    _ensureSuccess(response, uri);
    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw const FormatException('A API não retornou um herói.');
    }

    return HeroModel.fromJson(Map<String, dynamic>.from(decoded));
  }

  void dispose() => _client.close();

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

  void _ensureSuccess(http.Response response, Uri uri) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Falha ao acessar $uri: HTTP ${response.statusCode}.');
    }
  }
}
