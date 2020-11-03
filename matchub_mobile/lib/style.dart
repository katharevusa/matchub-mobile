import 'package:flutter/material.dart';
import 'package:matchub_mobile/sizeconfig.dart';

const kPrimaryColor = Color(0xFF28A29C);
// const kPrimaryColor = Color(0xFF40858C);
const kAccentColor = Color(0xFFfc8b6f);
const kSecondaryColor = Color(0xFF70A9A1);
const kTertiaryColor = Color(0xFF70A9A1);
const kKanbanColor = Color(0XFF2CC09C);

const kTextColor = Color(0xFF50505D);
const kTextLightColor = Color(0xFF6A727D);
const kDividerGray = Color(0xFFEEEEEE);
const kScaffoldColor = Color(0xFFFAFAFA);

final focusedBorder = new UnderlineInputBorder(
  borderSide: BorderSide(color: kAccentColor),
);
final enabledBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: kSecondaryColor),
);
final inputTextStyle = TextStyle(
  color: kSecondaryColor,
  fontSize: 12,
);

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Color(0xFFFAFAFA);
  static const Color topBarBackgroundColor = Color(0xFF40858C);
  static const Color selectedTabBackgroundColor = Color(0xFFFFC442);
  static const Color unSelectedTabBackgroundColor = Color(0xFFFFFFFC);
  static const Color subTitleTextColor = Color(0xFF9F988F);

  static const Color project1 = Color(0xFFE22941);
  static const Color project2 = Color(0xFFEE846D);
  static const Color project3 = Color(0xFFFBDC83);
  static const Color project4 = Color(0xFF6BCDA5);
  static const Color project5 = Color(0xFFE0A5BE);
  static const Color project6 = Color(0xFF69528E);
  static const Color project7 = Color(0xFF1E1E1E);
  static const Color project8 = Color(0xFFA7796F);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
  );

  static final TextTheme lightTextTheme = TextTheme(
    title: titleLight,
    subtitle: subTitleLight,
    button: buttonLight,
    display2: searchLight,
    body1: selectedTabLight,
    body2: unSelectedTabLight,
  );

  static final TextStyle titleLight = TextStyle(
    color: Colors.black,
    fontSize: 2.5 * SizeConfig.textMultiplier,
    fontFamily: "Lato",
  );

  static final TextStyle subTitleLight = TextStyle(
    color: Colors.grey,
    fontSize: 1.5 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
    height: 1.3,
    fontFamily: "Lato",
  );

  static final TextStyle buttonLight = TextStyle(
    color: Colors.black,
    fontSize: 1.5 * SizeConfig.textMultiplier,
    fontFamily: "Lato",
  );

  static final TextStyle searchLight = TextStyle(
    color: Colors.grey[800],
    fontSize: 1.5 * SizeConfig.textMultiplier,
    fontFamily: "Lato",
  );

  static final TextStyle selectedTabLight = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 1.5 * SizeConfig.textMultiplier,
    fontFamily: "Lato",
  );

  static final TextStyle unSelectedTabLight = TextStyle(
    color: Colors.grey[850],
    fontWeight: FontWeight.w400,
    fontSize: 1.5 * SizeConfig.textMultiplier,
    height: 1.3,
    fontFamily: "Lato",
  );
}
