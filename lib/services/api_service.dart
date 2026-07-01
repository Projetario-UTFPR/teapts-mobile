import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:front_pi/services/api_client.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await api.post(path, data: body);

      if (response.data == null || response.data == "") return {};

      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<dynamic> get(String path) async {
    try {
      final response = await api.get(path);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<void> putRaw({
    required String url,
    required Uint8List bytes,
    required String contentType,
    required String fileName,
  }) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': contentType,
        'Content-Disposition': 'inline',
        'Content-Length': bytes.length.toString(),
      },
      body: bytes,
    );
  }

  static Exception _handleError(DioException e) {
    final responseData = e.response?.data;
    if (responseData is Map) {
      if (e.response?.statusCode == 422 && responseData['errors'] != null) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        final messages = errors.values.expand((val) => val as List).join('\n');
        return Exception(messages);
      }
      return Exception(responseData['message'] ?? 'Erro desconhecido');
    }
    return Exception(e.message ?? 'Erro na requisição');
  }
}
