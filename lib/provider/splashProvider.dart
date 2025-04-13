// import 'package:flutter/material.dart';
//
// class AnimationProvider with ChangeNotifier {
//   double _opacity = 0.0;
//   bool _isSplashFinished = false;
//
//   double get opacity => _opacity;
//   bool get isSplashFinished => _isSplashFinished;
//
//   void startSplashAnimation() {
//     _opacity = 1.0; // Fade in
//     notifyListeners();
//
//     Future.delayed(const Duration(seconds: 3), () {
//       _isSplashFinished = true;
//       notifyListeners();
//     });
//   }
//
//   void resetAnimation() {
//     _opacity = 0.0;
//     _isSplashFinished = false;
//     notifyListeners();
//   }
// }