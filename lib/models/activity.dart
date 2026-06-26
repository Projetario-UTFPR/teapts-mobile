class Activity {
  final String id;
  final String title;
  final int frequencyTimes;
  final dynamic intervalUnit; 
  final int durationValue;
  final String durationUnit;
  final String state;
  final DateTime createdAt;

  Activity({
    required this.id,
    required this.title,
    required this.frequencyTimes,
    required this.intervalUnit,
    required this.durationValue,
    required this.durationUnit,
    required this.state,
    required this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    final frequency = json['frequency'] as Map<String, dynamic>;
    // interval pode vir como [1, "day"] ou "week" dependendo do contexto
    final intervalRaw = frequency['interval'];
    final String intervalUnit;
    if (intervalRaw is List) {
      intervalUnit = intervalRaw[1].toString();
    } else {
      intervalUnit = intervalRaw.toString();
    }

    final durationRaw = frequency['duration'] as List;

    return Activity(
      id: json['id'] as String,
      title: json['title'] as String,
      frequencyTimes: (frequency['times'] as num).toInt(),
      intervalUnit: intervalUnit,
      durationValue: (durationRaw[0] as num).toInt(),
      durationUnit: durationRaw[1].toString(),
      state: json['state'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}