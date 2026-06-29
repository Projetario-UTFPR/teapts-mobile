import 'package:dio/dio.dart';
import 'package:front_pi/models/professional.dart';
import 'package:front_pi/services/api_client.dart';

class ProfessionalService {
  static Future<PaginatedProfessionalsDto> getProfessionals({
    List<String>? ids,
    int? page,
  }) async {
    final Map<String, dynamic> parameters = {};
    if (ids != null && ids.isNotEmpty) parameters["inIds"] = ids;
    if (page != null) parameters["page"] = page;

    try {
      final response = await api.get(
        '/v1/professionals',
        queryParameters: parameters,
      );

      return PaginatedProfessionalsDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Erro ao buscar profissionais.',
      );
    }
  }
}
