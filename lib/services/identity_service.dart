import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_pi/config/app_config.dart';
import 'auth_service.dart';

class IdentityService {
  static String get baseUrl => AppConfig.baseUrl;

  static Future<List<Map<String, dynamic>>> getNonPatientAccounts({
    int page = 1,
    int limit = 24,
  }) async {
    final url = Uri.parse(
        '$baseUrl/v1/identities?page=$page&limit=$limit&isPatient=false');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final items = body['items'] as List;
      return items.cast<Map<String, dynamic>>();
    }

    if (response.statusCode == 401 ||
        response.statusCode == 403 ||
        response.statusCode == 422 ||
        response.statusCode == 500) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Erro ao buscar contas');
    }

    throw Exception('Erro inesperado: ${response.body}');
  }
}