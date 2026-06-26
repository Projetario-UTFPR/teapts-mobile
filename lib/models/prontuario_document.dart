import 'package:flutter/foundation.dart';

class ProntuarioDocument {
  final String id;
  final String title;
  final String? description;
  final String documentUrl;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  ProntuarioDocument({
    required this.id,
    required this.title,
    this.description,
    required this.documentUrl,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  static String _readString(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) return value.toString();
    }
    return fallback;
  }

  static String? _readNullableString(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) return value.toString();
    }
    return null;
  }

  static DateTime _readDate(
    Map<String, dynamic> json,
    List<String> keys, {
    DateTime? fallback,
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      try {
        if (value is DateTime) return value;
        return DateTime.parse(value.toString());
      } catch (_) {
        continue;
      }
    }
    return fallback ?? DateTime.now();
  }

  factory ProntuarioDocument.fromJson(Map<String, dynamic> json) {
    try {
      return ProntuarioDocument(
        id: _readString(json, ['id', '_id']),
        title: _readString(json, ['title', 'titulo'], fallback: 'Sem título'),
        description: _readNullableString(json, ['description', 'descricao']),
        documentUrl: _readString(json, ['documentUrl', 'document_url', 'url']),
        createdAt: _readDate(json, ['createdAt', 'created_at']),
        lastUpdatedAt: _readDate(
          json,
          ['lastUpdatedAt', 'last_updated_at', 'updatedAt', 'updated_at'],
        ),
      );
    } catch (e, st) {
      debugPrint('Erro ao parsear ProntuarioDocument. JSON recebido: $json');
      debugPrint('Erro: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'documentUrl': documentUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    };
  }
}