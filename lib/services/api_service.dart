import 'dart:typed_data';

class ApiService {
  static bool useMock = true;

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    if (useMock) return _mockPost(path, body);
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

  static Future<Map<String, dynamic>> _mockPost(
    String path,
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (path.startsWith('/v1/patient/') && path.endsWith('/prontuario/document/upload/initiate')) {
      return {
        'uploadUrl': 'https://mock-s3.example.com/upload/fake-key-123',
        'fileKey': 'fake-key-123.${_ext(body['fileName'])}',
      };
    }

    if (path.startsWith('/v1/patient/') && path.endsWith('/prontuario/document/upload')) {
      return {};
    }

    throw Exception('Mock: rota não mapeada — $path');
  }

  static Future<void> _mockPutRaw(
    String url,
    Uint8List bytes,
    String contentType,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));
    print('[MockApiService] PUT $url | ${bytes.length} bytes | $contentType');
  }

  static String _ext(dynamic fileName) {
    if (fileName is! String) return 'bin';
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last : 'bin';
  }
}