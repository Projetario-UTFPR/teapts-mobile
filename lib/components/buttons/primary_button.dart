import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconAlignment? iconAlignment;

  final bool isLoading;
  final bool isLinkButton;

  const PrimaryButton({
    super.key,
    required this.title,
    this.style,
    this.onPressed,
    this.isLoading = false,
    this.isLinkButton = false,
    this.icon,
    this.iconAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconAlignment =
        iconAlignment ?? style?.iconAlignment ?? IconAlignment.start;

    final effectiveIconWidget = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 1,
              color: Colors.black,
            ),
          )
        : icon != null
        ? PhosphorIcon(icon!, size: 20, color: Colors.black)
        : null;

    final text = Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );

    Widget child = text;

    if (isLinkButton) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text,
          Icon(PhosphorIcons.arrowRight(PhosphorIconsStyle.bold), size: 18),
        ],
      );
    } else if (effectiveIconWidget != null) {
      child = Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: effectiveIconAlignment == IconAlignment.start
            ? [effectiveIconWidget, text]
            : [text, effectiveIconWidget],
      );
    }

    return FilledButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
        shape: WidgetStateProperty.all(const StadiumBorder()),
        iconColor: WidgetStateProperty.all(Colors.black),
        backgroundColor: WidgetStateProperty.all(Styles.widgetYellow),
      ).merge(style),
      onPressed: isLoading ? null : onPressed,
      child: child,
    );
  }
}
