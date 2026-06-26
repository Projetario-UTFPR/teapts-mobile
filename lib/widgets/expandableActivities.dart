import 'package:flutter/material.dart';
import 'package:front_pi/widgets/add_activities.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/styles.dart';
import 'imageSideCard.dart';
import 'package:gap/gap.dart';
import '../services/activity_service.dart';

class ExpandableActivities extends StatefulWidget {
  final String patientId;

  const ExpandableActivities({super.key, required this.patientId});

  @override
  State<ExpandableActivities> createState() => _ExpandableActivitiesState();
}

class _ExpandableActivitiesState extends State<ExpandableActivities> {
  List<dynamic> _activities = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() => _isLoading = true);

    try {
      final response = await ActivityService.getActivities(
        widget.patientId,
        limit: 50,
      );

      if (!mounted) return;

      setState(() {
        _activities = response['items'] as List<dynamic>? ?? [];
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar atividades: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatFrequency(dynamic frequency) {
    if (frequency == null) return 'Frequência não informada';

    final int times = frequency['times'] ?? 1;

    int intervalValue = 1;
    String intervalUnit = 'week';

    if (frequency['interval'] is List && frequency['interval'].length >= 2) {
      intervalValue = frequency['interval'][0];
      intervalUnit = frequency['interval'][1];
    }

    final String wordTimes = times == 1 ? 'vez' : 'vezes';

    String translatedUnit = '';
    if (intervalUnit == 'day') {
      translatedUnit = intervalValue == 1 ? 'dia' : 'dias';
    } else if (intervalUnit == 'week') {
      translatedUnit = intervalValue == 1 ? 'semana' : 'semanas';
    } else if (intervalUnit == 'month') {
      translatedUnit = intervalValue == 1 ? 'mês' : 'meses';
    } else {
      translatedUnit = intervalUnit;
    }

    if (intervalValue == 1) {
      return '$times $wordTimes por $translatedUnit';
    } else {
      return '$times $wordTimes a cada $intervalValue $translatedUnit';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: const Text('Atividades', style: Styles.titlesBold),
        trailing: Icon(
          PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
          size: 24,
          color: Styles.widgetBlackCarret,
        ),
        shape: const Border(),
        children: [
          const Gap(16),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            )
          else if (_activities.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Nenhuma atividade sugerida para este PTS.',
                style: Styles.midSize,
              ),
            )
          else
            ..._activities.map(
              (activity) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomRowItem(
                  title: activity['title'] ?? 'Sem título',
                  subtitle: _formatFrequency(activity['frequency']),
                  isCircularImage: false,
                  placeholderIcon: PhosphorIcons.videoConference(
                    PhosphorIconsStyle.fill,
                  ),
                  linkText: 'Ver mais detalhes',
                  onLinkTap: () =>
                      print('ID da atividade clicada: ${activity['id']}'),
                ),
              ),
            ),

          const Gap(8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                final bool? success = await addActivityPanel(
                  context,
                  widget.patientId,
                );
                if (success == true) {
                  _loadActivities();
                }
              },
              style: Styles.buttonYellow,
              icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold), size: 24),
              label: const Text('Adicionar nova atividade'),
            ),
          ),
        ],
      ),
    );
  }
}
