import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/appGreenButton.dart';
import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../resources/text_styles.dart';
import '../analysis/analysis.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Calculate responsive dimensions based on reference sizes
    final baseWidth = 375.0; // Typical mobile width as reference
    final scaleFactor = screenWidth / baseWidth;

    // Define maximum sizes
    final maxLogoWidth = 150.0;
    final maxButtonWidth = 277.0;
    final maxButtonHeight = 57.0;

    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.04),

                    // Logo
                    Hero(
                      tag: 'appLogo',
                      child: Image.asset(
                        logo,
                        width: (maxLogoWidth * scaleFactor).clamp(100.0, maxLogoWidth),
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.06),

                    // Component image
                    Center(
                      child: Image.asset(
                        meditation,
                        width: (screenWidth * 0.8).clamp(200.0, 400.0),
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.05),

                    // Welcome text
                    Text(
                      'Welcome to EchoMind!',
                      style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                          color: ColorManager.white,
                          fontSize: (32 * scaleFactor).clamp(24.0, 32.0),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    Text(
                      "Let’s begin by understanding your thoughts.\nTake a moment to check in with\nyour mental space..",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        textStyle: smallTextOnboarding1.copyWith(
                          fontSize: (smallTextOnboarding1.fontSize ?? 14) * scaleFactor.clamp(0.85, 1.0),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.045),

                    // Button
                    AppGreenButton(
                      text: "Start Quiz",
                      height: (maxButtonHeight * scaleFactor).clamp(45.0, maxButtonHeight),
                      width: (maxButtonWidth * scaleFactor).clamp(200.0, maxButtonWidth),
                      fontSize: (16 * scaleFactor).clamp(14.0, 16.0),
                      showIcon: true,
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AnalysisCompleteScreen(),),
                        );
                      },
                    ),

                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}