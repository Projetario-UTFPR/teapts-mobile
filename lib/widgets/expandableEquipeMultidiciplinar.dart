import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/styles.dart';
import 'imageSideCard.dart';
import 'package:gap/gap.dart';

class ExpandableEquipeMultidiciplinar extends StatelessWidget {
  const ExpandableEquipeMultidiciplinar({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: const Text('Equipe Multidisciplinar', style: Styles.titlesBold),
        childrenPadding: EdgeInsets.zero,
        tilePadding: EdgeInsets.zero,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
              size: 24,
              color: Styles.widgetBlackCarret,
            ),

            const Gap(16),
            IconButton(
              icon: Icon(
                PhosphorIcons.pencilSimpleLine(PhosphorIconsStyle.bold),
                size: 24,
                color: Styles.widgetBlack,
              ),
              onPressed: () {
                //TODO: mandar para pagina para editar o conteudo de situação social
              },
              style: IconButton.styleFrom(
                backgroundColor: Styles.widgetYellow,
                padding: const EdgeInsets.all(0),
                shape: CircleBorder(),
              ),
            ),
          ],
        ),
        shape: const Border(),

        children: [
          const Gap(24),
          CustomRowItem(
            title: 'Jhon Doe',
            subtitle: 'Pscicólogo',
            isCircularImage: true,
            placeholderIcon: Icons.person,
            onLinkTap: () => print('Tapped Beta'),
          ),

          const Gap(8),

          CustomRowItem(
            title: 'Jhon Doe',
            subtitle: 'Pscicólogo',
            isCircularImage: true,
            placeholderIcon: Icons.person,
            onLinkTap: () => print('Tapped Beta'),
          ),

          const Gap(8),
        ],
      ),
    );
  }
}
