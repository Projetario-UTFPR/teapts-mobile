const Map<String, String> _specialityLabels = {
  'PSYCHOLOGIST': 'Psicólogo(a)',
  'PSYCHIATRIST': 'Psiquiatra',
  'SOCIAL_WORKER': 'Assistente Social',
  'OCCUPATIONAL_THERAPIST': 'Terapeuta Ocupacional',
  'NURSE': 'Enfermeiro(a)',
  'DOCTOR': 'Médico(a)',
  'PHYSIOTHERAPIST': 'Fisioterapeuta',
  'SPEECH_THERAPIST': 'Fonoaudiólogo(a)',
  'NUTRITIONIST': 'Nutricionista',
  'PHARMACIST': 'Farmacêutico(a)',
};

String mapSpecialism(String? raw) {
  return _specialityLabels[raw?.toUpperCase()] ?? 'Outro';
}

class PaginatedProfessionalsDto {
  final int page;
  final int perPage;
  final int totalElements;
  final List<ProfessionalDto> items;

  PaginatedProfessionalsDto({
    required this.page,
    required this.perPage,
    required this.totalElements,
    required this.items,
  });

  factory PaginatedProfessionalsDto.fromJson(Map<String, dynamic> json) {
    return PaginatedProfessionalsDto(
      page: json['page'] as int,
      perPage: json['perPage'] as int,
      totalElements: json['totalElements'] as int,
      items: (json['items'] as List<dynamic>)
          .map((item) => ProfessionalDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'perPage': perPage,
      'totalElements': totalElements,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ProfessionalDto {
  final String professionalId;
  final String accountId;
  final String name;
  final String email;
  final String specialism;
  final DateTime? lastUpdatedAt;
  final DateTime createdAt;

  ProfessionalDto({
    required this.professionalId,
    required this.accountId,
    required this.name,
    required this.email,
    required this.specialism,
    this.lastUpdatedAt,
    required this.createdAt,
  });

  factory ProfessionalDto.fromJson(Map<String, dynamic> json) {
    return ProfessionalDto(
      professionalId: json['professionalId'] as String,
      accountId: json['accountId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      specialism: json['specialism'] as String,
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'professionalId': professionalId,
      'accountId': accountId,
      'name': name,
      'email': email,
      'specialism': specialism,
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
