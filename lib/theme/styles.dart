import 'package:flutter/material.dart';
class Styles {
  static const Color bgColor = Color(0Xfffafafa);
  static const Color widgetYellow = Color(0Xffffc200);
  static const Color widgetWhite = Color.fromRGBO(254, 254, 254, 1);
  static const Color widgetBlack = Color(0Xff161616);
  static const Color widgetBlack40 = Color.fromARGB(28, 22, 22, 22); //40% para alpha menor
  static const Color widgetBlackCarret = Color(0XFF555555); 
  static const Color IconLightGray =  Color(0X11000000); 
  static const Color IconDarkGray = Color(0XFF999999);
  static const Color linkOrange = Color.fromARGB(255, 210, 145, 4);

  static const TextStyle titles = TextStyle(
    fontSize: 24,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
  );

    static const TextStyle titlesBold = TextStyle(
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
  );

  static const TextStyle midSize = TextStyle(
    fontSize: 18,
    fontFamily: 'Roboto',
  );

    static const TextStyle midSizeBold = TextStyle(
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
  );

    static const TextStyle linkBold = TextStyle(
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    color: linkOrange,
  ); 

  static const TextStyle normalText = TextStyle(
    fontSize: 16,
    fontFamily: 'Roboto',
  );

    static const TextStyle normalTextBold = TextStyle(
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
  );

  static final ButtonStyle buttonYellow = FilledButton.styleFrom(
    backgroundColor: widgetYellow,
    foregroundColor: widgetBlack,
    padding: const EdgeInsets.symmetric(vertical: 18),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: Styles.midSizeBold,
  );

  static final ButtonStyle buttonWhite = FilledButton.styleFrom(
    backgroundColor: Styles.widgetWhite,
    foregroundColor: Styles.widgetBlack,
    padding: const EdgeInsets.symmetric(vertical: 18),
    side: BorderSide(color: widgetBlack40),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: Styles.titlesBold,
  );
}