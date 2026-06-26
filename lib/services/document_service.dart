import 'dart:typed_data';
import 'package:front_pi/services/api_service.dart';

class DocumentService {
  static String _getMimeType(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  static Future<List<dynamic>> getDocumentosDoProntuario(
    String patientId,
  ) async {
    final path = '/v1/patient/$patientId/prontuario?page=1&limit=10';
    final response = await ApiService.get(path);
    if (response != null && response['items'] != null) {
      return response['items'] as List<dynamic>;
    }
    return [];
  }

  static Future<void> uploadDocument({
    required String patientId,
    required String assigneeProfessionalId,
    required String documentTitle,
    String? documentDescription,
    required Uint8List documentContent,
    required String documentFileType,
    required String documentFileName,
  }) async {
    final mimeType = _getMimeType(documentFileType);

    final signedResponse = await ApiService.post(
      '/v1/patient/$patientId/prontuario/document/upload/initiate',
      {
        'fileName': documentFileName,
        'fileType': mimeType,
        'fileSize': documentContent.length,
      },
    );

    final uploadUrl = signedResponse['uploadUrl'];
    final fileKey = signedResponse['fileKey'];

    if (uploadUrl == null || fileKey == null) {
      throw Exception('Resposta inválida do servidor ao iniciar upload');
    }

    await ApiService.putRaw(
      url: uploadUrl as String,
      bytes: documentContent,
      contentType: mimeType,
      fileName: documentFileName,
    );

    await ApiService.post('/v1/patient/$patientId/prontuario/document/upload', {
      'assigneeProfessionalId': assigneeProfessionalId,
      'documentFileKey': fileKey as String,
      'documentTitle': documentTitle,
      if (documentDescription != null)
        'documentDescription': documentDescription,
    });
  }
}
