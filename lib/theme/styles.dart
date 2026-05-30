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

  static final ButtonStyle buttonYellow = FilledButton.styleFrom(
    backgroundColor: widgetYellow,
    foregroundColor: widgetBlack,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape:RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    shadowColor: widgetBlack40,
    elevation: 4,
  );

  static final ButtonStyle buttonWhite = FilledButton.styleFrom(
    backgroundColor: widgetWhite,
    foregroundColor: widgetBlack,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape:RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    shadowColor: widgetBlack40,
    elevation: 4,
  );


  static BoxDecoration boxWhite = BoxDecoration(
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