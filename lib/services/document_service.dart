import 'dart:typed_data';
import 'package:front_pi/services/api_service.dart'; // ou o que você usa pra fazer http

class DocumentService {
  static Future<void> uploadDocument({
    required String patientId,
    required String assigneeProfessionalId,
    required String documentTitle,
    String? documentDescription,
    required Uint8List documentContent,
    required String documentFileType,
    required String documentFileName,
  }) async {
    
    final signedResponse = await ApiService.post('/documents/signed-url', {
      'patientId': patientId,
      'assigneeProfessionalId': assigneeProfessionalId,
      'documentTitle': documentTitle,
      if (documentDescription != null)
        'documentDescription': documentDescription,
      'documentFileName': documentFileName,
      'documentFileType': documentFileType,
    });

    final uploadUrl = signedResponse['uploadUrl'] as String;
    final fileKey = signedResponse['fileKey'] as String;


    await ApiService.putRaw(
      url: uploadUrl,
      bytes: documentContent,
      contentType: documentFileType,
    );

    await ApiService.post('/documents', {
      'patientId': patientId,
      'assigneeProfessionalId': assigneeProfessionalId,
      'documentFileKey': fileKey,
      'documentTitle': documentTitle,
      if (documentDescription != null)
        'documentDescription': documentDescription,
    });
  }
}