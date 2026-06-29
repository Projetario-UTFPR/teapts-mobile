class PTSDto {
  final String id;
  final PatientDto patient;
  final ResponsibleProfessionalDto responsibleProfessional;
  final List<String> multidisciplinaryTeam;
  final String? socialSituation;
  final String status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final DateTime? beganAt;
  final DateTime? concludedAt;
  final DateTime? cancelledAt;

  PTSDto({
    required this.id,
    required this.patient,
    required this.responsibleProfessional,
    this.socialSituation,
    required this.status,
    required this.createdAt,
    required this.multidisciplinaryTeam,
    this.acceptedAt,
    this.rejectedAt,
    this.beganAt,
    this.concludedAt,
    this.cancelledAt,
  });

  factory PTSDto.fromJson(Map<String, dynamic> json) {
    return PTSDto(
      id: json['id'] as String,
      patient: PatientDto.fromJson(json['patient'] as Map<String, dynamic>),
      responsibleProfessional: ResponsibleProfessionalDto.fromJson(
        json['responsibleProfessional'] as Map<String, dynamic>,
      ),
      multidisciplinaryTeam:
          (json["multidisciplinaryTeamIds"] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      socialSituation: json['socialSituation'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'] as String)
          : null,
      rejectedAt: json['rejectedAt'] != null
          ? DateTime.parse(json['rejectedAt'] as String)
          : null,
      beganAt: json['beganAt'] != null
          ? DateTime.parse(json['beganAt'] as String)
          : null,
      concludedAt: json['concludedAt'] != null
          ? DateTime.parse(json['concludedAt'] as String)
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient': patient.toJson(),
      'responsibleProfessional': responsibleProfessional.toJson(),
      'multidisciplinaryTeamIds': multidisciplinaryTeam,
      if (socialSituation != null) 'socialSituation': socialSituation,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'beganAt': beganAt?.toIso8601String(),
      'concludedAt': concludedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }
}

class PatientDto {
  final List<SupportContactDto> supportContacts;

  PatientDto({required this.supportContacts});

  factory PatientDto.fromJson(Map<String, dynamic> json) {
    return PatientDto(
      supportContacts:
          (json['supportContacts'] as List<dynamic>?)
              ?.map(
                (e) => SupportContactDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'supportContacts': supportContacts.map((e) => e.toJson()).toList()};
  }
}

class SupportContactDto {
  final String name;
  final String description;
  final String phone;
  final String? email;

  SupportContactDto({
    required this.name,
    required this.description,
    required this.phone,
    this.email,
  });

  factory SupportContactDto.fromJson(Map<String, dynamic> json) {
    return SupportContactDto(
      name: json['name'] as String,
      description: json['description'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'phone': phone,
      if (email != null) 'email': email,
    };
  }
}

class ResponsibleProfessionalDto {
  final String professionalId;
  final String accountId;
  final String name;
  final String email;
  final String specialism;
  final DateTime? lastUpdatedAt;
  final DateTime createdAt;

  ResponsibleProfessionalDto({
    required this.professionalId,
    required this.accountId,
    required this.name,
    required this.email,
    required this.specialism,
    this.lastUpdatedAt,
    required this.createdAt,
  });

  factory ResponsibleProfessionalDto.fromJson(Map<String, dynamic> json) {
    return ResponsibleProfessionalDto(
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
      if (lastUpdatedAt != null)
        'lastUpdatedAt': lastUpdatedAt!.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
