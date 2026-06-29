import 'package:dio/dio.dart';
import 'package:front_pi/services/auth_service.dart';

final Dio api = Dio(
  BaseOptions(
    baseUrl: AuthService.baseUrl,
    contentType: 'application/json',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

void setupApiClient() {
  api.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (AuthService.accessToken != null) {
          options.headers['Authorization'] =
              'Bearer ${AuthService.accessToken}';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          AuthService.logout();
        }
        return handler.next(e);
      },
    ),
  );
}
