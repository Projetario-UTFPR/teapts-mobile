import 'dart:convert';
import 'package:front_pi/models/pts.dart';
import 'package:http/http.dart' as http;
import 'package:front_pi/config/app_config.dart';
import 'auth_service.dart';

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
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
      body: jsonEncode({
        'professionalId': professionalId,
        'patientId': patientId,
        'socialSituation': socialSituation,
        'multidisciplinaryTeamIds': multidisciplinaryTeamIds,
      }),
    );

    if (response.statusCode == 201) return;

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

  static Future<bool> checkSelfHasActivePts() async {
    final auth = AuthService.authCollection;
    if (auth == null || !auth.isPatient) return false;

    try {
      await PtsService.getPts(auth.account.id);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<PTSDto> getPts(String patientId) async {
    final url = Uri.parse('$baseUrl/v1/pts/$patientId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final json = await jsonDecode(response.body);
      return PTSDto.fromJson(json);
    }

    if (response.statusCode == 403 || response.statusCode == 500) {
      final body = jsonDecode(response.body);
      throw Exception(body['message']);
    }

    throw Exception('Erro inesperado: ${response.body}');
  }

  static Future<Map<String, dynamic>> getMyPatients({
    int page = 1,
    int limit = 24,
  }) async {
    final url = Uri.parse('$baseUrl/v1/patients/me?page=$page&limit=$limit');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    if (response.statusCode == 422 || response.statusCode == 500) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Erro ao buscar pacientes');
    }

    throw Exception('Erro inesperado: ${response.body}');
  }
}
