import 'api_service.dart';

class TimelineService {
  static Future<Map<String, dynamic>> getTimeline(
    String patientId,
    int page,
    int limit,
  ) async {
    final path = '/v1/pts/$patientId/timeline?page=$page&limit=$limit';

    final response = await ApiService.get(path);
    return response ?? {};
  }
}
