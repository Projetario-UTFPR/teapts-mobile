import 'package:flutter/material.dart';
import 'package:front_pi/theme/styles.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final ButtonStyle? style;
  final VoidCallback? onPressed;

  final bool isLoading;
  final bool isLinkButton;

  const SecondaryButton({
    super.key,
    required this.title,
    this.style,
    this.onPressed,
    this.isLoading = false,
    this.isLinkButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );

    final child = isLinkButton
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text,
              Icon(PhosphorIcons.arrowRight(PhosphorIconsStyle.bold), size: 18),
            ],
          )
        : text;

    return OutlinedButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
        shape: WidgetStateProperty.all(const StadiumBorder()),
        iconColor: WidgetStateProperty.all(Styles.IconDarkGray),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        side: WidgetStateProperty.all(
          BorderSide(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      ).merge(style),
      onPressed: isLoading ? null : onPressed,
      child: child,
    );
  }
}
