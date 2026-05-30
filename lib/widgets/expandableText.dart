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
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: const Text('Situação social', style: Styles.h2),
        shape: const Border(),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(PhosphorIcons.caretDown()), 

            const SizedBox(width: 12),
            
            IconButton(
              icon: Icon(PhosphorIcons.pencilSimpleLine()),
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: Styles.widgetYellow,
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
        ),
        children: [
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
                  child: FilledButton(
                    style: Styles.buttonWhite,
                    onPressed: () {
                      final String typedText = _noteController.text;
                      print('User saved this note: $typedText');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ver mais'),
                        Icon(PhosphorIcons.arrowRight()),
                      ],
                    ),
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
