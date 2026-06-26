import 'package:flutter/material.dart';
import 'package:front_pi/screens/timeline/timeline_item.dart';
import 'package:front_pi/widgets/mainAppBar.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  static const int _pageSize = 5;

  // TODO: substituir por chamada real ao endpoint quando existir
  final List<dynamic> _allEvents = [
    (
      professional: 'João Silva',
      speciality: "Psicólogo(a)",
      activityName: 'Consulta inicial',
      dateTime: DateTime(2024, 5, 10, 14, 30),
    ),
    (
      professional: 'Ana Souza',
      speciality: "Psicólogo(a)",
      activityName: 'Sessão de fisioterapia',
      dateTime: DateTime(2024, 5, 11, 9, 0),
    ),
    (
      professional: 'Bruno Lima',
      speciality: "Psicólogo(a)",
      activityName: 'Avaliação psiquiátrica',
      dateTime: DateTime(2024, 5, 12, 11, 15),
    ),
    (
      professional: 'Carla Mendes',
      speciality: "Psicólogo(a)",
      activityName: 'Retorno nutricional',
      dateTime: DateTime(2024, 5, 13, 16, 0),
    ),
    (
      professional: 'Antonio Costa',
      speciality: "Psicólogo(a)",
      activityName: 'Reunião de equipe',
      dateTime: DateTime(2024, 5, 14, 8, 45),
    ),
    (
      professional: 'Diego Alves',
      speciality: "Psicólogo(a)",
      activityName: 'Sessão de psicologia',
      dateTime: DateTime(2024, 5, 15, 10, 0),
    ),
    (
      professional: 'Fernanda Rocha',
      speciality: "Psicólogo(a)",
      activityName: 'Avaliação de enfermagem',
      dateTime: DateTime(2024, 5, 16, 13, 30),
    ),
  ];

  int _visibleCount = _pageSize;

  void _loadMore() {
    setState(() {
      _visibleCount = (_visibleCount + _pageSize).clamp(0, _allEvents.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleEvents = _allEvents.take(_visibleCount).toList();
    final hasMore = _visibleCount < _allEvents.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(title: "Timeline"),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Confira os registros dos acontecimentos mais recentes no seu Plano Terapêutico Singular (PTS).',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: visibleEvents.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == visibleEvents.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC200),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _loadMore,
                          child: const Text(
                            'Carregar mais',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  final event = visibleEvents[index];
                  final isFirst = index == 0;
                  final isLast = index == visibleEvents.length - 1 && !hasMore;
                  final position = isFirst
                      ? Position.first
                      : isLast
                      ? Position.last
                      : Position.middle;

                  return TimelineItem(
                    professionalName: event.professional,
                    professionalSpeciality: event.speciality,
                    eventDescription: event.activityName,
                    eventDateTime: event.dateTime,
                    position: position,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
