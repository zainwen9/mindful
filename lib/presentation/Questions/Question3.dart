import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_health/widgets/appGreenButton.dart';
import '../../../widgets/mentalButton.dart';
import '../../../widgets/symptomsOrangeContainer.dart';
import '../../resources/app_colors.dart';
import 'Question4.dart';

class questionThree extends StatefulWidget {
  const questionThree({Key? key}) : super(key: key);

  @override
  State<questionThree> createState() => _questionThreeState();
}

class _questionThreeState extends State<questionThree> with TickerProviderStateMixin {
  final List<String> symptoms = [
    'I sleep well\nand wake up\nrested',
    'I have trouble\nfalling asleep',
    'I wake up\noften during the\nnight',
    'I sleep\ntoo much',
    'I hardly\nsleep at\nall',
  ];

  String? selectedSymptom; // Tracks the single selected symptom

  late List<AnimationController> _animationControllers;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();

    _animationControllers = List.generate(
      symptoms.length,
          (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800 + (index * 50)),
      ),
    );

    _animations = List.generate(
      symptoms.length,
          (index) => Tween<Offset>(
        begin: const Offset(0, -0.7),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationControllers[index],
        curve: Curves.easeOutQuint,
      )),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var i = 0; i < _animationControllers.length; i++) {
        Future.delayed(
          Duration(milliseconds: 80 * i),
              () => _animationControllers[i].forward(),
        );
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
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
              Color(0xFF5A0A5C),
              Color(0xFF31024A),
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
                          'Sleep Cycle',
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
                      'How have you been sleeping recently?',
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: (16 * scaleFactor).clamp(12.0, 16.0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  const mentalButton(text: 'Sleep'),

                  SizedBox(height: screenHeight * 0.01),

                  SizedBox(
                    height: (screenHeight * 0.4).clamp(400.0, 480.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          left: 0,
                          top: (20 * scaleFactor).clamp(10.0, 20.0),
                          child: SlideTransition(
                            position: _animations[0],
                            child: _buildCircle(symptoms[0], 100 * scaleFactor),
                          ),
                        ),
                        Positioned(
                          left: screenWidth * 0.28,
                          top: (100 * scaleFactor).clamp(80.0, 100.0),
                          child: SlideTransition(
                            position: _animations[1],
                            child: _buildCircle(symptoms[1], 96 * scaleFactor),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: (1 * scaleFactor).clamp(0.0, 1.0),
                          child: SlideTransition(
                            position: _animations[2],
                            child: _buildCircle(symptoms[2], 120 * scaleFactor),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: (300 * scaleFactor).clamp(250.0, 300.0),
                          child: SlideTransition(
                            position: _animations[3],
                            child: _buildCircle(symptoms[3], 100 * scaleFactor),
                          ),
                        ),
                        Positioned(
                          left: screenWidth * 0.28,
                          top: (240 * scaleFactor).clamp(200.0, 240.0),
                          child: SlideTransition(
                            position: _animations[4],
                            child: _buildCircle(symptoms[4], 116 * scaleFactor),
                          ),
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
                          MaterialPageRoute(builder: (context) => const questionFour()),
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
    final isSelected = selectedSymptom == text;

    Color backgroundColor = Colors.transparent;
    if (isSelected) {
      backgroundColor = ColorManager.yellowCircle; // Use yellow for the single selection
    }

    final scaleFactor = MediaQuery.of(context).size.width / 375.0;
    final scaledDiameter = diameter.clamp(70.0, diameter);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSymptom = null; // Deselect if already selected
          } else {
            selectedSymptom = text; // Select the new symptom
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