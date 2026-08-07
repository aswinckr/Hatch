import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  static const title = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.espresso,
  );
  static const body = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 16,
    height: 1.35,
    color: AppColors.espresso,
  );

  static const cupertino = CupertinoTextThemeData(
    textStyle: body,
    actionTextStyle: TextStyle(fontFamily: 'Outfit', fontSize: 17),
    tabLabelTextStyle: TextStyle(fontFamily: 'Outfit', fontSize: 10),
    navTitleTextStyle: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ),
    navLargeTitleTextStyle: TextStyle(
      fontFamily: 'Outfit',
      fontSize: 34,
      fontWeight: FontWeight.w700,
    ),
    navActionTextStyle: TextStyle(fontFamily: 'Outfit', fontSize: 17),
    pickerTextStyle: TextStyle(fontFamily: 'Outfit', fontSize: 21),
    dateTimePickerTextStyle: TextStyle(fontFamily: 'Outfit', fontSize: 21),
  );
}
