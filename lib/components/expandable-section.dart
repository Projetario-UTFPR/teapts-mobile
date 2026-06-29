import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/styles.dart';
import 'package:gap/gap.dart';

class ExpandableSection extends StatefulWidget {
  final String title;
  final List<Widget> actions;
  final List<Widget> children;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.actions,
    required this.children,
  });

  @override
  State<StatefulWidget> createState() {
    return _ExpandableSectionState();
  }
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      childrenPadding: EdgeInsets.zero,
      tilePadding: EdgeInsets.zero,

      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },

      trailing: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          AnimatedRotation(
            // 45 graus -> 0 graus
            turns: _isExpanded ? 0.0 : 0.25,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
              size: 24,
              color: Styles.widgetBlackCarret,
            ),
          ),

          const Gap(16),
          ...widget.actions,
        ],
      ),
      shape: const Border(),

      children: [
        const Gap(12),
        Column(spacing: 8, children: widget.children),
      ],
    );
  }
}
