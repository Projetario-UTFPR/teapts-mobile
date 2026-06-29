import 'dart:convert';
import 'package:front_pi/models/auth_collection.dart';
import 'package:http/http.dart' as http;
import 'package:front_pi/config/app_config.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static String get baseUrl => AppConfig.baseUrl;

  static String? accessToken;
  static String? refreshToken;
  static AuthCollectionDto? authCollection;
  static bool get isPatient => authCollection?.isPatient ?? false;

  @Deprecated("Use `authCollection` instead")
  static String? accountId;

  @Deprecated("Use `authCollection` instead")
  static String? professionalId;

  static List<Map<String, dynamic>> professionalProfiles = [];

  static final ValueNotifier<bool> authNotifier = ValueNotifier(false);

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/v1/sessions/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      accessToken = body['accessToken'];
      refreshToken = body['refreshToken'];
      final authCollectionJson = body['authCollection'];

      if (authCollectionJson == null) {
        throw Exception(
          'Não foi possível carregar os dados da sua conta. Faça login novamente.',
        );
      }

      accountId = authCollectionJson['account']['id'];

      professionalProfiles = List<Map<String, dynamic>>.from(
        authCollectionJson['professionalProfiles'] ?? [],
      );

      if (professionalProfiles.length == 1) {
        professionalId = professionalProfiles.first['professionalId'];
      } else {
        professionalId = null;
      }

      authCollection = AuthCollectionDto.fromJson(authCollectionJson);

      authNotifier.value = true;
      return;
    }

    if (response.statusCode == 401) {
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

  static void logout() {
    accessToken = null;
    refreshToken = null;
    accountId = null;
    professionalId = null;
    professionalProfiles = [];
    authCollection = null;
    authNotifier.value = false;
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
      body: jsonEncode({'email': email, 'name': name, 'password': password}),
    );

    if (response.statusCode == 204) {
      return;
    }

    final body = jsonDecode(response.body);

    if (response.statusCode == 409) {
      throw Exception(body['message'] ?? 'Conta já existe');
    }

    if (response.statusCode == 422) {
      final errors = body['errors'] as Map<String, dynamic>;
      final messages = errors.values.expand((e) => e as List).join('\n');
      throw Exception(messages);
    }

    throw Exception('Erro inesperado: ${response.body}');
  }
}
