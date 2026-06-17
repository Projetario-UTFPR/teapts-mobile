import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/auth_service.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:3000'; 

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final token = AuthService.accessToken; 
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 204) return {};

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      final msg = decoded['message'] ?? decoded['errors']?.toString() ?? 'Erro desconhecido';
      throw Exception(msg);
    }

    return decoded as Map<String, dynamic>;
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

      if (response.statusCode != 200 && response.statusCode != 204) {
         throw Exception('Falha no upload do arquivo: ${response.statusCode}');
    }
  }
}