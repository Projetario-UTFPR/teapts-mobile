import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_pi/config/app_config.dart';

class PtsService {
  static String get baseUrl => AppConfig.baseUrl;

static Future<void> createPts({
    required String professionalId,
    required String patientId,
    required String socialSituation,
    List<String> multidisciplinaryTeamIds = const [],
  }) async {
    final url = Uri.parse('$baseUrl/v1/pts/create');

  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'professionalId': professionalId,
        'patientId': patientId,
        'socialSituation': socialSituation,
        'multidisciplinaryTeamIds': multidisciplinaryTeamIds,
      }),
    );

    if (response.statusCode == 200) return;

    if (response.statusCode == 400 ||
        response.statusCode == 403 ||
        response.statusCode == 409 ||
        response.statusCode == 500) {
      final body = jsonDecode(response.body);
      throw Exception(body['message']);
    }

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      final errors = body['errors'] as Map<String, dynamic>;
      final messages = errors.values.expand((e) => e as List).join('\n');
      throw Exception(messages);
    }

    throw Exception('Erro inesperado: ${response.body}');
  }
}