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
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) {
        if (AuthService.accessToken != null) {
          options.headers['Authorization'] =
              'Bearer ${AuthService.accessToken}';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          try {
            await AuthService.refreshSession();
            e.requestOptions.headers['Authorization'] =
                'Bearer ${AuthService.accessToken}';

            final cloneReq = await api.fetch(e.requestOptions);
            return handler.resolve(cloneReq);
          } catch (refreshError) {
            return handler.next(e);
          }
        }
        return handler.next(e);
      },
    ),
  );
}
