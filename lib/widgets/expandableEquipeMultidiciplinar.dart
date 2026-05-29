import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/styles.dart';
import 'imageSideCard.dart';

class ExpandableEquipeMultidiciplinar extends StatelessWidget {
  const ExpandableEquipeMultidiciplinar({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: const Text('Equipe Multidisciplinar', style: Styles.h2),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            IconButton(
              icon: Icon(PhosphorIcons.caretDown()),
              onPressed: () {
              },
            ),

            IconButton(
              icon: Icon(PhosphorIcons.pencilSimpleLine()),
              onPressed: () {
              },
            ),
          ],
        ),
        shape: const Border(),
        children: [
          const Divider(
            height: 1,
          ), 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomRowItem(
                  title: 'Jhon Doe',
                  subtitle: 'Pscicólogo',
                  isCircularImage: true,
                  placeholderIcon: Icons.person,
                  onLinkTap: () => print('Tapped Beta'),
                ),

                const SizedBox(height: 16), 

                CustomRowItem(
                  title: 'Jhon Doe',
                  subtitle: 'Pscicólogo',
                  isCircularImage: true,
                  placeholderIcon: Icons.person,
                  onLinkTap: () => print('Tapped Beta'),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
