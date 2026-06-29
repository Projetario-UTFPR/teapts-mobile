class AuthCollectionDto {
  final AccountDto account;
  final List<AuthProfessionalProfileDto> professionalProfiles;
  final bool isPatient;

  AuthCollectionDto({
    required this.account,
    required this.professionalProfiles,
    required this.isPatient,
  });

  factory AuthCollectionDto.fromJson(Map<String, dynamic> json) {
    return AuthCollectionDto(
      account: AccountDto.fromJson(json['account'] as Map<String, dynamic>),
      professionalProfiles:
          (json['professionalProfiles'] as List<dynamic>? ?? [])
              .map(
                (e) => AuthProfessionalProfileDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      isPatient: json['isPatient'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account.toJson(),
      'professionalProfiles': professionalProfiles
          .map((e) => e.toJson())
          .toList(),
      'isPatient': isPatient,
    };
  }
}

class AccountDto {
  final String id;
  final String name;
  final String role;

  AccountDto({required this.id, required this.name, required this.role});

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    return AccountDto(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'role': role};
  }
}

class AuthProfessionalProfileDto {
  final String professionalId;
  final String specialism;

  AuthProfessionalProfileDto({
    required this.professionalId,
    required this.specialism,
  });

  factory AuthProfessionalProfileDto.fromJson(Map<String, dynamic> json) {
    return AuthProfessionalProfileDto(
      professionalId: json['professionalId'] as String,
      specialism: json['specialism'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'professionalId': professionalId, 'specialism': specialism};
  }
}
