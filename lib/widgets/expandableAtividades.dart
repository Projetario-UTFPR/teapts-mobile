import 'package:flutter/material.dart';
import '../theme/styles.dart'; 
import 'imageSideCard.dart'; 

class ExpandableAtividades extends StatelessWidget {
  const ExpandableAtividades({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: const Text(
          'Atividades',
          style: Styles.h2,
        ),

        shape: const Border(), 
        children: [
          const Divider(height: 1),
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
                
                const SizedBox(height: 16),
                
                CustomRowItem(
                  title: 'Acompanhamento com psicólogo',
                  subtitle: '1 vez a cada semana',
                  isCircularImage: false,
                  placeholderIcon: Icons.folder,
                  linkText: 'Ver mais detalhes',
                  onLinkTap: () => print('Tapped Alpha'),
                ),
                
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {},
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