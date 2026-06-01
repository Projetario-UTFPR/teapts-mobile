import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// Renamed slightly to reflect its new purpose!
class ExpandableTextDisplay extends StatefulWidget {
  const ExpandableTextDisplay({super.key});

  @override
  State<ExpandableTextDisplay> createState() => _ExpandableTextDisplayState();
}

class _ExpandableTextDisplayState extends State<ExpandableTextDisplay> {
  
  String _displayText = "Texto de exemplo sobre o que vai ter nesse campo. Aqui deve ser puxado do backend as informações sobre o paciente deste Pts";

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
        title: const Text('Situação social', style: Styles.titlesBold),
        shape: const Border(),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.caretDown(PhosphorIconsStyle.bold), size: 24,color: Styles.widgetBlackCarret), 
            const SizedBox(width: 24),
            IconButton(
              icon: Icon(PhosphorIcons.pencilSimpleLine(PhosphorIconsStyle.bold),size: 24,color: Styles.widgetBlack),
              onPressed: () {
                //TODO: mandar para pagina para editar o conteudo de situação social
              },
              style: IconButton.styleFrom(
                backgroundColor: Styles.widgetYellow,
                padding: const EdgeInsets.all(0),
                shape: CircleBorder()
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
                
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    
                  ),
                  child: Text(
                    _displayText, // Uses your variable here
                    style: Styles.normalText,
                  ),
                ),

                const SizedBox(height: 12),

                // 3. YOUR EXISTING BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    style: Styles.buttonWhite.copyWith(textStyle: WidgetStateProperty.all(Styles.midSizeBold)),
                    onPressed: () {
                      print('Viewing more details for: $_displayText');
                    },
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ver mais'),
                          Icon(PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),size: 24,),
                        ],
                      ),
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