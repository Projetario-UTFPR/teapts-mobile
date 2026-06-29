import 'package:dio/dio.dart';
import 'package:front_pi/models/prontuario_document.dart';
import 'package:front_pi/services/api_client.dart';

class ProntuarioService {
  static Future<(List<ProntuarioDocument>, int)> getDocuments({
    required String patientId,
    int page = 1,
    int limit = 24,
  }) async {
    try {
      final response = await api.get(
        '/v1/patient/$patientId/prontuario',
        queryParameters: {'page': page, 'limit': limit},
      );

      final body = response.data;
      final items = body['items'] as List;

      return (
        items
            .map((d) => ProntuarioDocument.fromJson(d as Map<String, dynamic>))
            .toList(),
        body["totalElements"] as int,
      );
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map) {
        if (e.response?.statusCode == 422 && responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final messages = errors.values
              .expand((val) => val as List)
              .join('\n');
          throw Exception(messages);
        }
        throw Exception(responseData['message'] ?? 'Erro inesperado.');
      }
      throw Exception(e.message ?? 'Erro na requisição');
    }
  }
}
