class PaginatedPatientsDto {
  final int page;
  final int perPage;
  final int totalElements;
  final List<PatientDto> items;

  PaginatedPatientsDto({
    required this.page,
    required this.perPage,
    required this.totalElements,
    required this.items,
  });

  factory PaginatedPatientsDto.fromJson(Map<String, dynamic> json) {
    return PaginatedPatientsDto(
      page: json['page'] as int,
      perPage: json['perPage'] as int,
      totalElements: json['totalElements'] as int,
      items: (json['items'] as List<dynamic>)
          .map((item) => PatientDto.fromJson(item as Map<String, dynamic>))
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

class PatientDto {
  final String accountId;
  final String name;
  final String email;
  final List<SupportContactDto> supportContacts;
  final DateTime? lastUpdatedAt;
  final DateTime createdAt;

  PatientDto({
    required this.accountId,
    required this.name,
    required this.email,
    required this.supportContacts,
    this.lastUpdatedAt,
    required this.createdAt,
  });

  factory PatientDto.fromJson(Map<String, dynamic> json) {
    return PatientDto(
      accountId: json['accountId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      supportContacts: (json['supportContacts'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                SupportContactDto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      lastUpdatedAt: json['lastUpdatedAt'] != null
          ? DateTime.parse(json['lastUpdatedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'name': name,
      'email': email,
      'supportContacts': supportContacts.map((e) => e.toJson()).toList(),
      'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class SupportContactDto {
  final String name;
  final String? description;
  final String? phone;
  final String? email;

  SupportContactDto({
    required this.name,
    this.description,
    this.phone,
    this.email,
  });

  factory SupportContactDto.fromJson(Map<String, dynamic> json) {
    return SupportContactDto(
      name: json['name'] as String,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'phone': phone,
      'email': email,
    };
  }
}