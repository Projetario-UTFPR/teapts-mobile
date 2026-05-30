import 'package:flutter/material.dart';
import '../theme/styles.dart'; 
import 'imageSideCard.dart'; 

class ExpandableAtividades extends StatelessWidget {
  const ExpandableAtividades({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: const Text(
          'Atividades',
          style: Styles.h2,
        ),

        shape: const Border(), 
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomRowItem(
                  title: 'Acompanhamento com psicólogo',
                  subtitle: '1 vez a cada semana',
                  isCircularImage: false,
                  placeholderIcon: Icons.folder,
                  linkText: 'Ver mais detalhes',
                  onLinkTap: () => print('Tapped Alpha'),
                ),
                
                const SizedBox(height: 8),
                
                CustomRowItem(
                  title: 'Acompanhamento com psicólogo',
                  subtitle: '1 vez a cada semana',
                  isCircularImage: false,
                  placeholderIcon: Icons.folder,
                  linkText: 'Ver mais detalhes',
                  onLinkTap: () => print('Tapped Alpha'),
                ),
                
                const SizedBox(height: 8),
                
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {},
                    style: Styles.buttonYellow,
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.add),
                    label: const Text('adicionar nova atividade'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}