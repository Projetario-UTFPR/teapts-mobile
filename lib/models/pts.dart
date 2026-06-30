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
      id: json['id']?.toString() ?? '',
      patient: PatientDto.fromJson(
        (json['patient'] as Map<String, dynamic>?) ?? {},
      ),
      responsibleProfessional: ResponsibleProfessionalDto.fromJson(
        (json['responsibleProfessional'] as Map<String, dynamic>?) ?? {},
      ),
      multidisciplinaryTeam:
          (json['multidisciplinaryTeamIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      socialSituation: json['socialSituation']?.toString(),
      status: json['status']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.tryParse(json['acceptedAt'].toString())
          : null,
      rejectedAt: json['rejectedAt'] != null
          ? DateTime.tryParse(json['rejectedAt'].toString())
          : null,
      beganAt: json['beganAt'] != null
          ? DateTime.tryParse(json['beganAt'].toString())
          : null,
      concludedAt: json['concludedAt'] != null
          ? DateTime.tryParse(json['concludedAt'].toString())
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.tryParse(json['cancelledAt'].toString())
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
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
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
      professionalId: json['professionalId']?.toString() ?? '',
      accountId: json['accountId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      specialism: json['specialism']?.toString() ?? '',
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.tryParse(json['lastUpdatedAt'].toString())
          : null,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
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

class PTSProposalDto {
  final String id;
  final ResponsibleProfessionalDto responsibleProfessional;
  final List<ProposalTeamMemberDto> multidisciplinaryTeam;

  PTSProposalDto({
    required this.id,
    required this.responsibleProfessional,
    required this.multidisciplinaryTeam,
  });

  String get responsibleName => responsibleProfessional.name;
  String get responsibleRole => responsibleProfessional.specialism;
  String? get responsibleAvatarUrl => null;

  factory PTSProposalDto.fromJson(Map<String, dynamic> json) {
    return PTSProposalDto(
      id: json['id']?.toString() ?? '',
      responsibleProfessional: ResponsibleProfessionalDto.fromJson(
        (json['responsibleProfessional'] as Map<String, dynamic>?) ?? {},
      ),
      multidisciplinaryTeam:
          (json['multidisciplinaryTeam'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ProposalTeamMemberDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'responsibleProfessional': responsibleProfessional.toJson(),
      'multidisciplinaryTeam': multidisciplinaryTeam
          .map((e) => e.toJson())
          .toList(),
    };
  }
}

class ProposalTeamMemberDto {
  final String professionalId;
  final String name;
  final String specialism;

  ProposalTeamMemberDto({
    required this.professionalId,
    required this.name,
    required this.specialism,
  });

  factory ProposalTeamMemberDto.fromJson(Map<String, dynamic> json) {
    return ProposalTeamMemberDto(
      professionalId: json['professionalId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialism: json['specialism']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'professionalId': professionalId,
      'name': name,
      'specialism': specialism,
    };
  }
}
