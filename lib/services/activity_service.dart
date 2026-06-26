import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_pi/config/app_config.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/models/activity.dart';

class ActivityService {
  static String get baseUrl => AppConfig.baseUrl;

  static Future<List<Activity>> getActivities({
    required String patientId,
    int page = 1,
    int limit = 24,
  }) async {
    final url = Uri.parse(
      '$baseUrl/v1/pts/$patientId/activity?page=$page&limit=$limit',
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
      return items
          .map((a) => Activity.fromJson(a as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 400 ||
        response.statusCode == 403 ||
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

  static Future<void> createActivity({
    required String patientId,
    required String title,
    required String professionalId,
    required List<String> documentsIds,
    required int frequencyTimes,
    required String frequencyInterval,
    required int durationValue,
    required String durationUnit,
  }) async {
    final url = Uri.parse('$baseUrl/v1/pts/$patientId/activity/create');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
      body: jsonEncode({
        'title': title,
        'professionalId': professionalId,
        'documentsIds': documentsIds,
        'frequency': {
          'times': frequencyTimes,
          'interval': frequencyInterval,
          'duration': [durationValue, durationUnit],
        },
      }),
    );

    if (response.statusCode == 201) return;

    if (response.statusCode == 400 ||
        response.statusCode == 403 ||
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