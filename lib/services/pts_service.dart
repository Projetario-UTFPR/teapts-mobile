import 'dart:convert';
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

  static Future<List<Map<String, String>>> getProfissionais() async {
  final url = Uri.parse('$baseUrl/v1/professionals');

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
    return items.map<Map<String, String>>((p) => {
      'id': p['professionalId'].toString(),
      'nome': p['name'].toString(),
      'area': (p['specialism'] ?? 'Não informado').toString(),
    }).toList();
  }

  throw Exception('Erro ao buscar profissionais');  
}
}