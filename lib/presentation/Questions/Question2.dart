import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_health/widgets/appGreenButton.dart';
import '../../../widgets/mentalButton.dart';
import '../../resources/app_colors.dart';
import '../../widgets/symptomsOrangeContainer.dart';
import 'Question3.dart';

class questionTwo extends StatefulWidget {
  const questionTwo({Key? key}) : super(key: key);

  @override
  State<questionTwo> createState() => _questionTwoState();
}

class _questionTwoState extends State<questionTwo> with SingleTickerProviderStateMixin {
  final List<String> symptoms = [
    'Feeling hopeless\nor empty',
    'OverThinking',
    'Mood Swings',
    'Loneliness',
    'Difficulty concentrating',
    'Loss of interest in activities',
    'None of\nthe above',
  ];

  final Map<String, bool> selectedSymptoms = {};
  String? firstSelected;

  late AnimationController _guiltAnimationController;
  late Animation<Offset> _guiltAnimation;

  @override
  void initState() {
    super.initState();

    _guiltAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _guiltAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _guiltAnimationController,
      curve: Curves.easeOutBack,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _guiltAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _guiltAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = screenWidth / 375.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF1F4287),
              Color(0xFF0C1E5B),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: (24 * scaleFactor).clamp(18.0, 24.0),
                            ),
                          ),
                        ),
                        Text(
                          'Emotions',
                          style: GoogleFonts.bayon(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: (28 * scaleFactor).clamp(20.0, 28.0),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const symptomsOrangeContainer(),

                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Text(
                      'Have you been experiencing any of these lately?',
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: (16 * scaleFactor).clamp(12.0, 16.0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  const mentalButton(text: 'Emotions'),

                  SizedBox(height: screenHeight * 0.01),

                  SizedBox(
                    height: (screenHeight * 0.45).clamp(400.0, 480.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          left: 0,
                          top: (10 * scaleFactor).clamp(5.0, 10.0),
                          child: _buildCircle(symptoms[0], 100 * scaleFactor),
                        ),
                        Positioned(
                          left: screenWidth * 0.28,
                          top: (70 * scaleFactor).clamp(50.0, 70.0),
                          child: SlideTransition(
                            position: _guiltAnimation,
                            child: _buildCircle(symptoms[1], 96 * scaleFactor),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: (1 * scaleFactor).clamp(0.0, 1.0),
                          child: _buildCircle(symptoms[2], 120 * scaleFactor),
                        ),
                        Positioned(
                          left: 0,
                          top: (150 * scaleFactor).clamp(120.0, 150.0),
                          child: _buildCircle(symptoms[3], 100 * scaleFactor),
                        ),
                        Positioned(
                          left: screenWidth * 0.28,
                          top: (195 * scaleFactor).clamp(160.0, 195.0),
                          child: _buildCircle(symptoms[4], 116 * scaleFactor),
                        ),
                        Positioned(
                          right: (10 * scaleFactor).clamp(5.0, 10.0),
                          top: (160 * scaleFactor).clamp(130.0, 160.0),
                          child: _buildCircle(symptoms[5], 90 * scaleFactor),
                        ),
                        Positioned(
                          left: 0,
                          top: (290 * scaleFactor).clamp(240.0, 290.0),
                          child: _buildCircle(symptoms[6], 116 * scaleFactor),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: AppGreenButton(
                      text: 'Next',
                      height: (52 * scaleFactor).clamp(45.0, 52.0),
                      width: (screenWidth * 0.8).clamp(280.0, 320.0),
                      fontSize: (16 * scaleFactor).clamp(14.0, 16.0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const questionThree()),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(String text, double diameter) {
    final isSelected = selectedSymptoms[text] ?? false;
    final isFirstSelected = firstSelected == text;

    Color backgroundColor = Colors.transparent;
    if (isSelected) {
      backgroundColor = isFirstSelected
          ? ColorManager.yellowCircle
          : ColorManager.orangeCircle;
    }

    final scaleFactor = MediaQuery.of(context).size.width / 375.0;
    final scaledDiameter = diameter.clamp(70.0, diameter);

    return GestureDetector(
      onTap: () {
        setState(() {
          const noneOption = 'None of\nthe above';

          if (text == noneOption) {
            // If "None of the above" is tapped
            if (isSelected) {
              // Deselect "None of the above"
              selectedSymptoms.remove(text);
              firstSelected = null;
            } else {
              // Select "None of the above" and clear all other selections
              selectedSymptoms.clear();
              selectedSymptoms[text] = true;
              firstSelected = text;
            }
          } else {
            // If any other symptom is tapped
            if (selectedSymptoms[noneOption] == true) {
              // Deselect "None of the above" if it was selected
              selectedSymptoms.remove(noneOption);
              firstSelected = null;
            }

            // Toggle the tapped symptom
            if (isSelected) {
              // Deselect the symptom
              selectedSymptoms.remove(text);
              if (firstSelected == text) {
                firstSelected = selectedSymptoms.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .firstOrNull;
              }
            } else {
              // Select the symptom
              selectedSymptoms[text] = true;
              if (firstSelected == null) {
                firstSelected = text;
              }
            }
          }
        });
      },
      child: Container(
        width: scaledDiameter,
        height: scaledDiameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: Colors.white, width: (1.5 * scaleFactor).clamp(1.0, 1.5)),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(6.0 * scaleFactor.clamp(0.7, 1.0)),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: (12 * scaleFactor).clamp(8.0, 12.0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}