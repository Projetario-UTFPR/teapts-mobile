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

Future<void>? _refreshFuture;

void setupApiClient() {
  api.interceptors.clear();

  api.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (AuthService.accessToken != null) {
          options.headers['Authorization'] =
              'Bearer ${AuthService.accessToken}';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          if (e.requestOptions.path.contains('/v1/sessions/refresh')) {
            AuthService.logout();
            return handler.next(e);
          }

          if (_refreshFuture != null) {
            try {
              await _refreshFuture;

              final retryOptions = e.requestOptions;
              retryOptions.headers['Authorization'] =
                  'Bearer ${AuthService.accessToken}';

              final retryDio = Dio(api.options);
              final response = await retryDio.fetch(retryOptions);
              return handler.resolve(response);
            } catch (err) {
              return handler.next(e);
            }
          }

          try {
            _refreshFuture = AuthService.refreshSession();
            await _refreshFuture;

            final retryOptions = e.requestOptions;
            retryOptions.headers['Authorization'] =
                'Bearer ${AuthService.accessToken}';

            final retryDio = Dio(api.options);
            final response = await retryDio.fetch(retryOptions);
            return handler.resolve(response);
          } catch (refreshError) {
            AuthService.logout();
            return handler.next(e);
          } finally {
            _refreshFuture = null;
          }
        }
        return handler.next(e);
      },
    ),
  );
}
