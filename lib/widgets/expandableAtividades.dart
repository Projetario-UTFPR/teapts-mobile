import 'package:flutter/material.dart';
import 'package:front_pi/widgets/add_activities.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/styles.dart';
import 'imageSideCard.dart';
import 'package:gap/gap.dart';

import '../services/activity_service.dart';

class ExpandableAtividades extends StatefulWidget {
  final String patientId;

  const ExpandableAtividades({super.key, required this.patientId});

  @override
  State<ExpandableAtividades> createState() => _ExpandableAtividadesState();
}

class _ExpandableAtividadesState extends State<ExpandableAtividades> {
  List<dynamic> _atividades = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _buscarAtividadesDoBackend();
  }

  Future<void> _buscarAtividadesDoBackend() async {
    setState(() => _isLoading = true);

    try {
      final response = await ActivityService.getActivities(
        widget.patientId,
        limit: 50,
      );
      if (!mounted) return;

      setState(() {
        _atividades = response['items'] as List<dynamic>? ?? [];
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

  String _formatarFrequencia(dynamic freq) {
    if (freq == null) return 'Frequência não informada';

    final int times = freq['times'] ?? 1;
    int intervalValue = 1;
    String intervalUnit = 'week';

    if (freq['interval'] is List && freq['interval'].length >= 2) {
      intervalValue = freq['interval'][0];
      intervalUnit = freq['interval'][1];
    }

    final Map<String, String> traducoes = {
      'day': 'dia',
      'week': 'semana',
      'month': 'mês',
    };

    final translatedUnit = traducoes[intervalUnit] ?? intervalUnit;
    if (intervalValue == 1) {
      return '$times vez(es) por $translatedUnit';
    } else {
      return '$times vez(es) a cada $intervalValue $translatedUnit(s)';
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
          else if (_atividades.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Nenhuma atividade sugerida para este PTS.',
                style: Styles.midSize,
              ),
            )
          else
            ..._atividades.map(
              (atividade) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomRowItem(
                  title: atividade['title'] ?? 'Sem título',
                  subtitle: _formatarFrequencia(atividade['frequency']),
                  isCircularImage: false,
                  placeholderIcon: PhosphorIcons.videoConference(
                    PhosphorIconsStyle.fill,
                  ),
                  linkText: 'Ver mais detalhes',
                  onLinkTap: () =>
                      print('ID da atividade clicada: ${atividade['id']}'),
                ),
              ),
            ),

          const Gap(8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                final bool? salvouComSucesso = await addActivityPanel(
                  context,
                  widget.patientId,
                );
                if (salvouComSucesso == true) {
                  _buscarAtividadesDoBackend();
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
