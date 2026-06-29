import 'package:dio/dio.dart';
import 'package:front_pi/models/pts.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/api_client.dart';

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
  static Future<List<Map<String, String>>> getProfessionals() async {
  final url = Uri.parse('$baseUrl/v1/professionals');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthService.accessToken}',
    },
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    final items = body['items'] as List;
    return items.map<Map<String, String>>((p) => {
      'id': p['professionalId'].toString(),
      'accountId': p['accountId'].toString(),
      'name': p['name'].toString(),
      'specialism': (p['specialism'] ?? 'Not informed').toString(),
    }).toList();
  }

  throw Exception('Erro ao buscar profissionais');
}
static Future<List<PTSProposalDto>> getProposals(
  String patientId,{
  int page = 1,
  int limit = 24,
}) async {
  final url = Uri.parse(
    '$baseUrl/v1/pts/proposals/me?page=$page&limit=$limit',
  );

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthService.accessToken}',
    },
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final items = body['items'] as List;

    return items
        .map((e) => PTSProposalDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  if (response.statusCode == 403) {
    throw Exception('Usuário não é paciente');
  }

  throw Exception('Erro ao buscar propostas: ${response.body}');
  }
  static Future<void> rejectProposal(String patientId, String proposalId) async {
  final url = Uri.parse('$baseUrl/v1/pts/proposals/$proposalId/reject');

  final response = await http.patch(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthService.accessToken}',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 204) return;

  final body = jsonDecode(response.body);
  throw Exception(body['message'] ?? 'Erro ao rejeitar proposta');
  }
  static Future<void> acceptProposal(String proposalId) async {
    final url = Uri.parse('$baseUrl/v1/pts/proposals/$proposalId/accept');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) return;

    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? 'Erro ao aceitar proposta');
  }
}  
