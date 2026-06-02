import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/styles.dart';
import 'imageSideCard.dart';
import 'package:gap/gap.dart';

class ExpandableAtividades extends StatelessWidget {
  const ExpandableAtividades({super.key});

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
          CustomRowItem(
            title: 'Acompanhamento com psicólogo',
            subtitle: '1 vez a cada semana',
            isCircularImage: false,
            placeholderIcon: PhosphorIcons.videoConference(
              PhosphorIconsStyle.fill,
            ),
            linkText: 'Ver mais detalhes',
            onLinkTap: () => print('Tapped Alpha'),
          ),

          const Gap(8),

          CustomRowItem(
            title: 'Acompanhamento com psicólogo',
            subtitle: '1 vez a cada semana',
            isCircularImage: false,
            placeholderIcon: PhosphorIcons.videoConference(
              PhosphorIconsStyle.fill,
            ),
            linkText: 'Ver mais detalhes',
            onLinkTap: () => print('Tapped Alpha'),
          ),

          const Gap(8),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {},
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
