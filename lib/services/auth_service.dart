import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_pi/config/app_config.dart';


class AuthService {
  static String get baseUrl => AppConfig.baseUrl;

  static String? accessToken;
  static String? professionalId;

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/v1/sessions/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      accessToken = body['accessToken'];
      // decodifica o JWT para pegar o ID
      final parts = accessToken!.split('.');
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
      );
      professionalId = payload['sub'];
      return;
  }


    if (response.statusCode == 401) {
      final body = jsonDecode(response.body);
      throw Exception(body['message']);
    }

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      final errors = body['errors'] as Map<String, dynamic>;
      final messages = errors.values
          .expand((e) => e as List)
          .join('\n');
      throw Exception(messages);
    }


    throw Exception('Erro inesperado: ${response.body}');
  }


  static Future<void> createAccount({
    required String email,
    required String name,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/v1/identities/create-account');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'name': name,
        'password': password,
      }),
    );



    if (response.statusCode == 204) {
      return; // success, no body
    }

    if (response.statusCode == 409) {
      final body = jsonDecode(response.body);
      throw Exception(body['message']);

    }

    if (response.statusCode == 422) {
      final body = jsonDecode(response.body);
      final errors = body['errors'] as Map<String, dynamic>;
      final messages = errors.values
          .expand((e) => e as List)
          .join('\n');
      throw Exception(messages);
    }


    throw Exception('Erro inesperado: ${response.body}');
  }
}