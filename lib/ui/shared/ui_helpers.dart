import 'package:flutter/material.dart';

/// Contains useful consts to reduce boilerplate and duplicate code
class UIHelper {
  // Vertical spacing constants. Adjust to your liking.
  static const double _VerticalSpaceSmall = 10.0;
  static const double _VerticalSpaceMedium = 20.0;
  static const double _VerticalSpaceLarge = 60.0;

  // Vertical spacing constants. Adjust to your liking.
  static const double _HorizontalSpaceSmall = 10.0;
  static const double _HorizontalSpaceMedium = 20.0;
  static const double _HorizontalSpaceLarge = 60.0;

  static const Widget verticalSpaceSmall =
      SizedBox(height: _VerticalSpaceSmall);
  static const Widget verticalSpaceMedium =
      SizedBox(height: _VerticalSpaceMedium);
  static const Widget verticalSpaceLarge =
      SizedBox(height: _VerticalSpaceLarge);

  static const Widget horizontalSpaceSmall =
      SizedBox(width: _HorizontalSpaceSmall);
  static const Widget horizontalSpaceMedium =
      SizedBox(width: _HorizontalSpaceMedium);
  static const Widget horizontalSpaceLarge =
      SizedBox(width: _HorizontalSpaceLarge);

  static ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
    backgroundColor: Colors.grey[700],
    brightness: Brightness.dark,
  );
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.red,
    accentColor: Colors.red[400],
    backgroundColor: Colors.grey[200],
    brightness: Brightness.light,
  );
}
