import 'package:flutter/cupertino.dart';
import '../core/design/app_colors.dart';
import '../core/design/app_typography.dart';

class HatchApp extends StatelessWidget {
  const HatchApp({super.key});
  @override
  Widget build(BuildContext context) => CupertinoApp(
    title: 'Favourite Menu',
    debugShowCheckedModeBanner: false,
    theme: const CupertinoThemeData(
      primaryColor: AppColors.terracotta,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: CupertinoTextThemeData(textStyle: AppTypography.body),
    ),
    home: const CupertinoPageScaffold(
      child: Center(child: Text('Favourite Menu')),
    ),
  );
}
