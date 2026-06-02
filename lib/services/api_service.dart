import 'dart:typed_data';

class ApiService {
  // Toggle para alternar entre mock e real
  static bool useMock = true;

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    if (useMock) return _mockPost(path, body);
    // TODO: implementação real com http/dio
    throw UnimplementedError('Backend não configurado');
  }

  static Future<void> putRaw({
    required String url,
    required Uint8List bytes,
    required String contentType,
  }) async {
    if (useMock) return _mockPutRaw(url, bytes, contentType);
    throw UnimplementedError('Backend não configurado');
  }

  // ── Mocks ──────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _mockPost(
    String path,
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800)); // simula latência

    switch (path) {
      case '/documents/signed-url':
        return {
          'uploadUrl': 'https://mock-s3.example.com/upload/fake-key-123',
          'fileKey': 'documents/${body['patientId']}/fake-key-123.${_ext(body['documentFileName'])}',
        };

      case '/documents':
        return {'id': 'doc_mock_${DateTime.now().millisecondsSinceEpoch}'};

      default:
        throw Exception('Mock: rota não mapeada — $path');
    }
  }

  static Future<void> _mockPutRaw(
    String url,
    Uint8List bytes,
    String contentType,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Só loga — não faz upload de verdade
    // ignore: avoid_print
    print('[MockApiService] PUT $url | ${bytes.length} bytes | $contentType');
  }

  static String _ext(dynamic fileName) {
    if (fileName is! String) return 'bin';
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last : 'bin';
  }
}