import 'package:flutter/material.dart';

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

  static final ButtonStyle buttonYellow = FilledButton.styleFrom(
    backgroundColor: widgetYellow,
    foregroundColor: widgetBlack,
    padding: const EdgeInsets.symmetric(vertical: 18),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: Styles.midSizeBold,
    minimumSize: const Size(120, 40),
  );

  static final ButtonStyle buttonWhite = FilledButton.styleFrom(
    backgroundColor: Styles.widgetWhite,
    foregroundColor: Styles.widgetBlack,
    padding: const EdgeInsets.symmetric(vertical: 18),
    side: BorderSide(color: widgetBlack40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    textStyle: Styles.titlesBold,
    minimumSize: const Size(120, 24),
  );

  static final OutlineInputBorder _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
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
}
