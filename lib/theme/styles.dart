import 'package:flutter/material.dart';
class Styles {
  static const Color bgColor = Color(0Xfffafafa);
  static const Color widgetYellow = Color(0Xffffc200);
  static const Color widgetWhite = Color(0Xfffefefe);
  static const Color widgetBlack = Color(0Xff161616); //40% para alpha menor
  static const Color widgetBlack40 = Color(0X64161616); //40% para alpha menor

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textFieldRegular = TextStyle(
    fontSize: 16,
    fontFamily: 'Roboto',
  );

  static BoxDecoration buttonYellow = BoxDecoration(
    color: widgetYellow,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: widgetBlack,
        blurRadius: 4,
        offset: Offset.fromDirection(0,0.4)
      )
    ]
  );

  static BoxDecoration buttonWhite = BoxDecoration(
    color: widgetWhite,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: widgetBlack,
        blurRadius: 4,
        offset: Offset.fromDirection(0,0.4)
      )
    ]
  );
}