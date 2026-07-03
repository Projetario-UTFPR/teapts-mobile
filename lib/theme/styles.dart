import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Styles {
  static const Color bgColor = Color(0Xfffafafa);
  static const Color widgetYellow = Color(0Xffffc200);
  static const Color widgetWhite = Color.fromRGBO(254, 254, 254, 1);
  static const Color widgetBlack = Color(0Xff161616);
  static const Color widgetBlack40 = Color.fromARGB(
    28,
    22,
    22,
    22,
  ); //40% para alpha menor
  static const Color widgetBlackCarret = Color(0XFF555555);
  static const Color IconLightGray = Color(0X11000000);
  static const Color IconDarkGray = Color(0XFF999999);
  static const Color gray500 = Color(0xff555555);
  static const Color linkOrange = Color.fromRGBO(255, 148, 0, 1);
  static const cyan500 = Color.fromRGBO(89, 185, 226, 1);

  static const TextStyle titles = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titlesBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitlesBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle midSize = TextStyle(fontSize: 18);

  static const TextStyle midSizeBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle linkBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: linkOrange,
  );

  static const TextStyle normalText = TextStyle(fontSize: 16);

  static const TextStyle normalTextBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.10)),
  );

  static final OutlineInputBorder _inputBorderFocused = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black54),
  );

  static final OutlineInputBorder _inputBorderError = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.red),
  );

  static InputDecoration textFieldDefault({
    required String labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: Styles.midSize,
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF000000), fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,

      border: _inputBorder,
      enabledBorder: _inputBorder,
      focusedBorder: _inputBorderFocused,
      errorBorder: _inputBorderError,
      focusedErrorBorder: _inputBorderError,
    );
  }

  static final OutlineInputBorder _activityInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
  );

  static final OutlineInputBorder _activityInputBorderFocused =
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black54),
      );

  static InputDecoration InputDecoratorDefault({
    required String hintText,
    IconData? prefixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      fillColor: const Color(0xFFFFFFFF),
      filled: true,
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF000000), fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 6.0),
              child: Icon(prefixIcon, size: 20, color: Styles.gray500),
            )
          : null,

      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      errorText: errorText,
      border: _activityInputBorder,
      enabledBorder: _activityInputBorder,
      focusedBorder: _activityInputBorderFocused,
      errorBorder: _inputBorderError,
      focusedErrorBorder: _inputBorderError,
    );
  }

  static Widget buildCustomInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    bool isMultiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Styles.normalTextBold),
        const Gap(4),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
          maxLines: isMultiline ? null : 1,
          minLines: isMultiline ? 3 : 1,
          onChanged: onChanged,
          validator: validator,
          decoration: Styles.InputDecoratorDefault(hintText: hint).copyWith(
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: suffixIcon,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
