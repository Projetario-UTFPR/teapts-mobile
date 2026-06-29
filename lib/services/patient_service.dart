import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_pi/config/app_config.dart';
import 'auth_service.dart';

class PatientService {
  static String get baseUrl => AppConfig.baseUrl;

  static Future<void> createPatientProfile({
    required String accountId,
    List<Map<String, String>> supportContacts = const [],
  }) async {
    final url = Uri.parse('$baseUrl/v1/patients/create');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
      body: jsonEncode({
        'accountId': accountId,
        'supportContacts': supportContacts,
      }),
    );

    if (response.statusCode == 201) return;

    if (response.statusCode == 400 ||
        response.statusCode == 403 ||
        response.statusCode == 500) {
      final body = jsonDecode(response.body);
      throw Exception(body['message']);
    }

    throw Exception('Erro inesperado: ${response.body}');
  }
}