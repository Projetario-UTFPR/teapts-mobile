import 'package:dio/dio.dart';
import 'package:front_pi/models/pts.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/api_client.dart';

// Instância global simples (ou use um Provider/GetIt)
final ptsState = PtsStateNotifier();

class PtsService {
  static Future<void> createPts({
    required String professionalId,
    required String patientId,
    required String socialSituation,
    List<String> multidisciplinaryTeamIds = const [],
  }) async {
    try {
      await api.post(
        '/v1/pts/create',
        data: {
          'professionalId': professionalId,
          'patientId': patientId,
          'socialSituation': socialSituation,
          'multidisciplinaryTeamIds': multidisciplinaryTeamIds,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<bool> checkSelfHasActivePts() async {
    final auth = AuthService.authCollection;
    if (auth == null || !auth.isPatient) return false;

    try {
      await getPts(auth.account.id);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<PTSDto> getPts(String patientId) async {
    try {
      final response = await api.get('/v1/pts/$patientId');
      return PTSDto.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> getMyPatients({
    int page = 1,
    int limit = 24,
  }) async {
    try {
      final response = await api.get(
        '/v1/patients/me',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<List<Map<String, String>>> getProfessionals() async {
    try {
      final response = await api.get('/v1/professionals');

      // O Dio já faz o decode automático do JSON, então response.data já é um Map/List
      final items = response.data['items'] as List;

      return items
          .map<Map<String, String>>(
            (p) => {
              'id': p['professionalId'].toString(),
              'accountId': p['accountId'].toString(),
              'name': p['name'].toString(),
              'specialism': (p['specialism'] ?? 'Not informed').toString(),
            },
          )
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<(List<PTSProposalDto>, int)> getProposals(
    String patientId, {
    int page = 1,
    int limit = 24,
  }) async {
    try {
      final response = await api.get(
        '/v1/pts/proposals/me',
        queryParameters: {'page': page, 'limit': limit},
      );

      final items = response.data['items'] as List;
      final proposals = items
          .map((e) => PTSProposalDto.fromJson(e as Map<String, dynamic>))
          .toList();

      return (proposals, response.data["totalElements"] as int);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw Exception('Usuário não é paciente');
      }
      throw _handleError(e);
    }
  }

  static Future<void> rejectProposal(
    String patientId,
    String proposalId,
  ) async {
    try {
      await api.patch('/v1/pts/$proposalId/reject');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<void> acceptProposal(String proposalId) async {
    try {
      await api.patch('/v1/pts/$proposalId/approve');
    } on DioException catch (e) {
      throw _handleError(e);
    }
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
    return Exception(e.message ?? 'Erro inesperado.');
  }
}
