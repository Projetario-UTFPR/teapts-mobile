import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum AlertType { info, error }

class _ColorSet {
  final Color icon;
  final Color background;
  final Color text;

  const _ColorSet({
    required this.icon,
    required this.background,
    required this.text,
  });
}

final colors = {
  AlertType.info: _ColorSet(
    icon: Styles.linkOrange,
    background: Styles.cyan500.withValues(alpha: 0.2),
    text: Colors.black87,
  ),
  AlertType.error: _ColorSet(
    icon: Colors.red,
    text: Colors.black87,
    background: Colors.red.shade100,
  ),
};

class Alert extends StatelessWidget {
  final AlertType type;
  final String message;

  const Alert({super.key, required this.message, this.type = AlertType.info});

  @override
  Widget build(BuildContext context) {
    final colorSet = colors[type]!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: colorSet.background,
      ),
      padding: EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          PhosphorIcon(
            PhosphorIconsFill.warning,
            size: 24,
            color: colorSet.icon,
          ),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorSet.text, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
