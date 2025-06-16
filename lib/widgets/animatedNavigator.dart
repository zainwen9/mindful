import 'package:flutter/material.dart';
import '../resources/global_context_key.dart';

class AppNavigator {
  static void off() {
    navigatorKey.currentState!.pop();
  }

  static void to(Widget destinationScreen) {
    navigatorKey.currentState!.push(
      createRoute(newPage: destinationScreen),
    );
  }

  static void toAndRemoveUntil(Widget destinationScreen) {
    navigatorKey.currentState!.pushAndRemoveUntil(
      createRoute(newPage: destinationScreen),
          (route) => false,
    );
  }

  static void toReplacement(Widget destinationScreen) {
    navigatorKey.currentState!.pushReplacement(
      createRoute(newPage: destinationScreen),
    );
  }
}

Route createRoute({newPage}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => newPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
