import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import '../resources/global_context_key.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snaki(
    {required String msg}) {
  return scaffoldMessengerKey.currentState!.showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: ColorManager.primary,
      behavior: SnackBarBehavior.floating,
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
