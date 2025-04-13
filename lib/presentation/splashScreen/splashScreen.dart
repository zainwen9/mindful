import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_health/resources/app_colors.dart';
import '../../resources/app_assets.dart';
import '../../resources/text_styles.dart';
import '../introPage/page1.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  bool _hasNavigated = false; // Flag to prevent multiple navigations
  double _opacity = 0.0; // Control opacity for animation
  bool _isSplashFinished = false; // Track animation completion

  @override
  void initState() {
    super.initState();
    // Defer the animation start until after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        startSplashAnimation();
      }
    });
  }

  void startSplashAnimation() {
    setState(() {
      _opacity = 1.0; // Fade in
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isSplashFinished = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final maxLogoWidth = screenWidth * 0.70;
    final maxLargeSpacing = screenHeight * 0.1;
    final maxSmallSpacing = screenHeight * 0.005;

    // Navigate when the splash animation is finished, but only once
    if (_isSplashFinished && !_hasNavigated && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasNavigated) {
          setState(() {
            _hasNavigated = true;
          });
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              pageBuilder: (context, animation, secondaryAnimation) => const Page1(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final widthScale = screenWidth < 400 ? screenWidth / 400 : 1.0;
            final heightScale = screenHeight < 600 ? screenHeight / 600 : 1.0;

            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 1000), // Fade-in duration
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: 'appLogo',
                            child: Image.asset(
                              logo, // Ensure 'logo' is defined in app_assets.dart
                              width: maxLogoWidth * widthScale,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: maxLargeSpacing * heightScale),
                          Text(
                            "Rewire your thoughts, reclaim your calm. ",
                            style: GoogleFonts.figtree(
                              textStyle: splahStyle, // Ensure this is defined correctly
                            ),
                            textAlign: TextAlign.center,
                            textScaleFactor: widthScale.clamp(0.85, 1.0),
                          ),
                          SizedBox(height: maxSmallSpacing * heightScale),
                          Text(
                            "Begin your EchoMind journey",
                            style: GoogleFonts.figtree(
                              textStyle: splashLightStyle, // Ensure this is defined
                            ),
                            textAlign: TextAlign.center,
                            textScaleFactor: widthScale.clamp(0.85, 1.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}