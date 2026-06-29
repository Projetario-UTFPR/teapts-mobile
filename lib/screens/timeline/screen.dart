import 'package:flutter/material.dart';
import 'package:front_pi/components/buttons/primary_button.dart';
import 'package:front_pi/screens/timeline/timeline_item.dart';
import 'package:front_pi/services/auth_service.dart';
import 'package:front_pi/services/timeline_service.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:front_pi/widgets/mainAppBar.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  static const int _limit = 5;
  final List<dynamic> _events = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchTimeline();
  }

  Future<void> _refreshTimeline() async {
    setState(() {
      _events.clear();
      _currentPage = 1;
      _hasMore = true;
    });

    await _fetchTimeline();
  }

  Future<void> _fetchTimeline() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final response = await TimelineService.getTimeline(
        AuthService.accountId!,
        _currentPage,
        _limit,
      );

      final items = response['items'] as List<dynamic>? ?? [];
      final totalElements = response['totalElements'] as int? ?? 0;

      if (!mounted) return;

      setState(() {
        _events.addAll(items);
        _currentPage++;

        _hasMore = _events.length < totalElements;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar histórico: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            if (_events.isEmpty && _isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_events.isEmpty && !_isLoading)
              const Expanded(
                child: Center(child: Text('Nenhum evento registrado ainda.')),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  color: Styles.widgetYellow,
                  onRefresh: _refreshTimeline,
                  child: ListView.builder(
                    itemCount: _events.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _events.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              title: "Carregar mais",
                              isLoading: _isLoading,
                              onPressed: _fetchTimeline,
                            ),
                          ),
                        );
                      }

                      final event = _events[index];
                      final isUnique = _events.length == 1;
                      final isFirst = index == 0;
                      final isLast = index == _events.length - 1 && !_hasMore;

                      Position position;

                      if (isUnique) {
                        position = Position.unique;
                      } else if (isFirst) {
                        position = Position.first;
                      } else if (isLast) {
                        position = Position.last;
                      } else {
                        position = Position.middle;
                      }

                      final DateTime parsedDate = event['happenedAt'] != null
                          ? DateTime.parse(event['happenedAt']).toLocal()
                          : DateTime.now();

                      final profName =
                          event['professional']?['name'] ??
                          'Equipe Multidisciplinar';
                      final profSpec =
                          event['professional']?['specialism'] ?? 'Atendimento';

                      return TimelineItem(
                        professionalName: profName,
                        professionalSpeciality: profSpec,
                        eventDescription:
                            event['description'] ?? 'Sem descrição',
                        eventDateTime: parsedDate,
                        position: position,
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
