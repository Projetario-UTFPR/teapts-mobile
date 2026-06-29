import 'dart:convert';
import 'package:front_pi/models/professional.dart';
import 'package:http/http.dart' as http;
import 'package:front_pi/config/app_config.dart';
import 'auth_service.dart';

class ProfessionalService {
  static String get baseUrl => AppConfig.baseUrl;

  static Future<PaginatedProfessionalsDto> getProfessionals({
    List<String>? ids,
    int? page,
  }) async {
    var url = Uri.parse('$baseUrl/v1/professionals');

    final Map<String, dynamic> parameters = {};
    if (ids != null) parameters["inIds"] = ids.isEmpty ? "" : ids;
    if (page != null) parameters["page"] = page.toString();

    url = url.replace(queryParameters: parameters);
    print(url.toString());
    print(parameters);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return PaginatedProfessionalsDto.fromJson(body);
    }

    throw Exception('Erro ao buscar profissionais.');
  }
}
