import 'package:flutter/material.dart';
import 'package:front_pi/components/expandable-section.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// Renamed slightly to reflect its new purpose!
class ExpandableTextDisplay extends StatefulWidget {
  const ExpandableTextDisplay({super.key});

  @override
  State<ExpandableTextDisplay> createState() => _ExpandableTextDisplayState();
}

class _ExpandableTextDisplayState extends State<ExpandableTextDisplay> {
  String _displayText =
      "Texto de exemplo sobre o que vai ter nesse campo. Aqui deve ser puxado do backend as informações sobre o paciente deste Pts";

  @override
  Widget build(BuildContext context) {
    return ExpandableSection(
      title: 'Situação social',
      actions: [
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
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Text(_displayText, style: Styles.normalText),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            style: Styles.buttonWhite.copyWith(
              textStyle: WidgetStateProperty.all(Styles.midSizeBold),
            ),
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ver mais'),
                  Icon(
                    PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
