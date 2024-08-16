import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Colors.red;
  static const Color backgroundColor = Colors.black;
  static const Color textColor = Colors.white;
  static const Color secondaryTextColor = Colors.grey;
  static const Color appBarColor = Colors.black;
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    color: AppColors.textColor,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.textColor,
    fontSize: 16,
  );

  static const TextStyle secondaryBody = TextStyle(
    color: AppColors.secondaryTextColor,
    fontSize: 14,
  );
}
