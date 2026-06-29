import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_pi/config/app_config.dart';
import 'package:front_pi/models/auth_collection.dart';

class AuthService {
  static String get baseUrl => AppConfig.baseUrl;
  static final Dio _authDio = Dio(
    BaseOptions(baseUrl: AppConfig.baseUrl, contentType: 'application/json'),
  );

  static const _storage = FlutterSecureStorage();

  static String? accessToken;
  static String? refreshToken;
  static AuthCollectionDto? authCollection;

  @Deprecated("Use `authCollection` instead")
  static String? accountId;

  @Deprecated("Use `authCollection` instead")
  static String? professionalId;

  static List<Map<String, dynamic>> professionalProfiles = [];

  static final ValueNotifier<bool> authNotifier = ValueNotifier(false);
  static Map<String, dynamic>? get activeProfessionalProfile {
    if (professionalProfiles.isEmpty) return null;
    return professionalProfiles.firstWhere(
      (p) => p['professionalId'] == professionalId,
      orElse: () => professionalProfiles.first,
    );
  }

  static String get currentUserName =>
      activeProfessionalProfile?['name'] ?? 'Usuário';

  static String get currentRole {
    final profile = activeProfessionalProfile;
    if (profile == null) return 'Profissional';

    final specialisms = profile['specialism'] as List<dynamic>? ?? [];
    return specialisms.isNotEmpty
        ? specialisms.first.toString()
        : 'Profissional';
  }

  static Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final response = await _authDio.post(
        '/v1/sessions/login',
        data: {'email': email, 'password': password},
      );

      final body = response.data;
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

      professionalId = professionalProfiles.length == 1
          ? professionalProfiles.first['professionalId']
          : null;

      authCollection = AuthCollectionDto.fromJson(authCollectionJson);
      if (rememberMe) {
        await _storage.write(key: 'accessToken', value: accessToken);
        await _storage.write(key: 'refreshToken', value: refreshToken);
        await _storage.write(key: 'accountId', value: accountId);
        if (professionalId != null) {
          await _storage.write(key: 'professionalId', value: professionalId);
        }
      } else {
        await _storage.deleteAll();
      }

      authNotifier.value = true;
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  static Future<void> refreshSession() async {
    final currentRefreshToken =
        refreshToken ?? await _storage.read(key: 'refreshToken');

    if (currentRefreshToken == null) {
      logout();
      throw Exception(
        'Nenhuma sessão ativa para renovar. Faça login novamente.',
      );
    }

    try {
      final response = await _authDio.patch(
        '/v1/sessions/refresh',
        data: {'refreshToken': currentRefreshToken},
      );

      final body = response.data;

      accessToken = body['accessToken'];
      refreshToken = body['refreshToken'];

      final authCollectionJson = body['authCollection'];
      accountId = authCollectionJson['account']['id'];

      professionalProfiles = List<Map<String, dynamic>>.from(
        authCollectionJson['professionalProfiles'] ?? [],
      );

      professionalId = professionalProfiles.length == 1
          ? professionalProfiles.first['professionalId']
          : null;

      authCollection = AuthCollectionDto.fromJson(authCollectionJson);

      final hasSavedToken = await _storage.read(key: 'refreshToken') != null;
      if (hasSavedToken) {
        await _storage.write(key: 'accessToken', value: accessToken);
        await _storage.write(key: 'refreshToken', value: refreshToken);
        await _storage.write(key: 'accountId', value: accountId);
        if (professionalId != null) {
          await _storage.write(key: 'professionalId', value: professionalId);
        }
      }

      authNotifier.value = true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        logout();
        throw Exception('Sua sessão expirou. Faça login novamente.');
      }
      throw Exception(_extractErrorMessage(e));
    }
  }

  static Future<void> createAccount({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      await _authDio.post(
        '/v1/identities/create-account',
        data: {'email': email, 'name': name, 'password': password},
      );
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e));
    }
  }

  static void logout() {
    accessToken = null;
    refreshToken = null;
    accountId = null;
    professionalId = null;
    professionalProfiles = [];
    authCollection = null;
    authNotifier.value = false;
    _storage.deleteAll();
  }

  static String _extractErrorMessage(DioException e) {
    final responseData = e.response?.data;

    if (responseData == null) return e.message ?? 'Erro inesperado de rede';

    if (e.response?.statusCode == 422 && responseData['errors'] is Map) {
      final errors = responseData['errors'] as Map<String, dynamic>;
      return errors.values.expand((val) => val as List).join('\n');
    }
    return responseData['message'] ?? 'Ocorreu um erro desconhecido.';
  }

  static Future<void> initializeSession() async {
    final savedRefreshToken = await _storage.read(key: 'refreshToken');

    if (savedRefreshToken != null) {
      try {
        refreshToken = savedRefreshToken;
        await refreshSession();
      } catch (_) {}
    }
  }
}
