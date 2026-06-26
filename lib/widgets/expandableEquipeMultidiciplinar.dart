import 'package:flutter/material.dart';
import 'package:front_pi/components/expandable-section.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/styles.dart';
import 'custom_row_item.dart';

class _ExpandableEquipeMultidisciplinarState
    extends State<ExpandableEquipeMultidisciplinar> {
  @override
  Widget build(BuildContext context) {
    return ExpandableSection(
      title: "Equipe multidisciplinar",
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
        CustomRowItem(
          title: 'Jhon Doe',
          subtitle: 'Pscicólogo',
          isCircularImage: true,
          placeholderIcon: Icons.person,
        ),

        CustomRowItem(
          title: 'Jhon Doe',
          subtitle: 'Pscicólogo',
          isCircularImage: true,
          placeholderIcon: Icons.person,
        ),
      ],
    );
  }
}

class ExpandableEquipeMultidisciplinar extends StatefulWidget {
  const ExpandableEquipeMultidisciplinar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpandableEquipeMultidisciplinarState();
  }
}
