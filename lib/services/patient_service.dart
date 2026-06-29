import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_pi/config/app_config.dart';
import 'package:front_pi/models/patient.dart';
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

  static Future<PaginatedPatientsDto> getPatients({
    bool? withActivePts,
    String? professionalAccountId,
    int? page,
    int? limit,
  }) async {
    var url = Uri.parse('$baseUrl/v1/patients');

    final Map<String, dynamic> parameters = {};
    if (withActivePts != null) {
      parameters['withActivePts'] = withActivePts.toString();
    }
    if (professionalAccountId != null) {
      parameters['professionalAccountId'] = professionalAccountId;
    }
    if (page != null) parameters['page'] = page.toString();
    if (limit != null) parameters['limit'] = limit.toString();

    url = url.replace(queryParameters: parameters);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return PaginatedPatientsDto.fromJson(body);
    }

    throw Exception('Erro ao buscar pacientes.');
  }
}