import 'api_service.dart';

class ActivityService {
  Future<String?> createActivity(
    String patientId,
    CreateActivityDto dto,
  ) async {
    try {
      await ApiService.post('/v1/pts/$patientId/activity/create', dto.toJson());
      return null;
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '').trim();
    }
  }
}

class FrequencyDto {
  final int times;
  final String interval;
  final int durationValue;
  final String durationUnit;

  FrequencyDto({
    required this.times,
    required this.interval,
    required this.durationValue,
    required this.durationUnit,
  });

  Map<String, dynamic> toJson() {
    return {
      'times': times,
      'interval': interval,
      'duration': [durationValue, durationUnit],
    };
  }
}

class CreateActivityDto {
  final String title;
  final String professionalId;
  final List<String> documentsIds;
  final FrequencyDto frequency;

  CreateActivityDto({
    required this.title,
    required this.professionalId,
    required this.documentsIds,
    required this.frequency,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'professionalId': professionalId,
      'documentsIds': documentsIds,
      'frequency': frequency.toJson(),
    };
  }
}
