import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  static const title = TextStyle(
    fontFamily: 'NotoSerif',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.espresso,
  );
  static const body = TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 16,
    height: 1.35,
    color: AppColors.espresso,
  );
}
