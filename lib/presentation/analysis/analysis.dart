import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_health/widgets/appGreenButton.dart';
import '../../resources/app_assets.dart';
import '../../resources/text_styles.dart';
import '../Questions/Question1.dart';


class AnalysisCompleteScreen extends StatelessWidget {
  const AnalysisCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'ANALYSIS Required',
                style: GoogleFonts.bayon(
                  textStyle:complete,
                ),),
              const SizedBox(height: 16),
              Image.asset(divider),
              const SizedBox(height: 24),
              Text(
                'Based on your responses, we will analyse your stress patterns:',
                style: GoogleFonts.outfit(
                  textStyle: response,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 250,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Financial Impact (Center Circle)
                    Positioned(
                      top: 80,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE07A67),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'OverThinking',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              textStyle: circleText,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Triggers & Habits (Top Left)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 126,
                        height: 126,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8A30C2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'Sleep\nCycle',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              textStyle: circleText,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Emotional State (Top Right)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 126,
                        height: 126,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2D472),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'Stress or\nEmotions',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              textStyle: emotionCircle,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Betting Patterns (Bottom Left)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 112,
                        height: 112,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3F5CED),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'Thoughts',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              textStyle: circleText,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Social Changes (Bottom Right)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 112,
                        height: 112,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC3C1E1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'Support',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                                textStyle: emotionCircle
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

            Image.asset(analysisComplete),
              const SizedBox(height: 14),

              Center(child: AppGreenButton(text: 'Continue', onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>question1(),),);
              },)),

              const Spacer(),

            ],
          ),
        ),
      ),
    );
  }
}