import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_pi/config/app_config.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/models/prontuario_document.dart';

class ProntuarioService {
  static String get baseUrl => AppConfig.baseUrl;

  static Future<(List<ProntuarioDocument>, int)> getDocuments({
    required String patientId,
    int page = 1,
    int limit = 24,
  }) async {
    final url = Uri.parse(
      '$baseUrl/v1/patient/$patientId/prontuario?page=$page&limit=$limit',
    );

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
      return (
        items
            .map((d) => ProntuarioDocument.fromJson(d as Map<String, dynamic>))
            .toList(),
        body["totalElements"] as int,
      );
    }

    if (response.statusCode == 403) {
      final body = jsonDecode(response.body);
      throw Exception(body['message']);
    }

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      final errors = body['errors'] as Map<String, dynamic>;
      final messages = errors.values.expand((e) => e as List).join('\n');
      throw Exception(messages);
    }

    if (response.statusCode == 500) {
      final body = jsonDecode(response.body);
      throw Exception(body['message']);
    }

    throw Exception('Erro inesperado: ${response.body}');
  }
}
