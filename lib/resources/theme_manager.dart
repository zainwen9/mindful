import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData getApplicatonTheme(){
  return ThemeData(
    primaryColor: ColorManager.primary,
        primaryColorLight: ColorManager.primaryOpactity70,
    disabledColor: ColorManager.grey,
    scaffoldBackgroundColor: ColorManager.backgroundColor,
  );
}