import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class expandableTextfield extends StatefulWidget {
  const expandableTextfield({super.key});

  @override
  State<expandableTextfield> createState() => _expandableTextfieldState();
}

class _expandableTextfieldState extends State<expandableTextfield> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

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
          'Situação social',
          style: Styles.h2,
        ),
        shape: const Border(),
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
        children: [
          const Divider(height: 1),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end, 
              children: [
                
                TextField(
                  controller: _noteController,
                  maxLines: 5, 
                  decoration: InputDecoration(
                    hintText: 'Type your notes or updates here...',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                  onPressed: () {
                    final String typedText = _noteController.text;
                    print('User saved this note: $typedText');
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),   
                  label: const Text('Ver mais'),   
                  icon: Icon(PhosphorIcons.plus())
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