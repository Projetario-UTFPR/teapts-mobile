import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../theme/styles.dart';
import 'imageSideCard.dart';
import 'package:front_pi/services/activity_service.dart';
import 'package:front_pi/models/activity.dart';

class ExpandableAtividades extends StatefulWidget {
  final String patientId;

  const ExpandableAtividades({super.key, required this.patientId});

  @override
  State<ExpandableAtividades> createState() => _ExpandableAtividadesState();
}

class _ExpandableAtividadesState extends State<ExpandableAtividades> {
  List<Activity> _activities = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await ActivityService.getActivities(
        patientId: widget.patientId,
      );
      setState(() => _activities = items);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatFrequency(Activity a) {
    final interval = a.intervalUnit == 'day'
        ? 'dia'
        : a.intervalUnit == 'week'
            ? 'semana'
            : 'mês';
    return '${a.frequencyTimes} vez${a.frequencyTimes > 1 ? 'es' : ''} por $interval';
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
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: Color(0xFFFFC200)),
              ),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_error!,
                  style: const TextStyle(color: Colors.red, fontSize: 13)),
            )
          else if (_activities.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Nenhuma atividade cadastrada.',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.45), fontSize: 13),
              ),
            )
          else
            ...List.generate(_activities.length, (i) {
              final a = _activities[i];
              return Column(
                children: [
                  CustomRowItem(
                    title: a.title,
                    subtitle: _formatFrequency(a),
                    isCircularImage: false,
                    placeholderIcon:
                        PhosphorIcons.videoConference(PhosphorIconsStyle.fill),
                    linkText: 'Ver mais detalhes',
                    onLinkTap: () {
                      // TODO: navegar para detalhe da atividade
                    },
                  ),
                  if (i < _activities.length - 1) const Gap(8),
                ],
              );
            }),

          const Gap(8),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context
                  .push('/create-activity/${widget.patientId}')
                  .then((_) => _load()),
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