import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_health/presentation/Questions/Question6.dart';

class QuestionFive extends StatefulWidget {
  const QuestionFive({Key? key}) : super(key: key);

  @override
  _QuestionFiveState createState() => _QuestionFiveState();
}

class _QuestionFiveState extends State<QuestionFive> with SingleTickerProviderStateMixin {
  double _stressLevel = 5.0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isSubmitted = false;

  // Your custom theme color
  final Color themeColor = const Color(0xFF080D13);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();

    // Set system UI overlay style for status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Get gradient colors based on stress level
  List<Color> _getGradientColors() {
    if (_stressLevel <= 3) {
      return [Colors.green.shade300, Colors.green.shade600];
    } else if (_stressLevel <= 7) {
      return [Colors.amber.shade300, Colors.orange.shade700];
    } else {
      return [Colors.orange.shade400, Colors.red.shade700];
    }
  }

  // Get emoji based on stress level
  String _getEmoji() {
    if (_stressLevel <= 2) return '😌';
    if (_stressLevel <= 4) return '🙂';
    if (_stressLevel <= 6) return '😐';
    if (_stressLevel <= 8) return '😟';
    return '😫';
  }

  // Get label based on stress level
  String _getLabel() {
    if (_stressLevel <= 2) return 'Very Low';
    if (_stressLevel <= 4) return 'Low';
    if (_stressLevel <= 6) return 'Moderate';
    if (_stressLevel <= 8) return 'High';
    return 'Extremely High';
  }

  // Navigate to next screen
  void _navigateToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  question6(),),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = screenWidth / 375.0;

    return Scaffold(
      backgroundColor: themeColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF1E3D32), // Dark Green from your previous screen
              Color(0xFF0B1612), // Almost Black from your previous screen
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -100,
              right: -100,
              child: Opacity(
                opacity: 0.07,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: gradientColors[1],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -80,
              left: -50,
              child: Opacity(
                opacity: 0.07,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: gradientColors[0],
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: FadeTransition(
                opacity: _animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(_animation),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0 * scaleFactor),
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
                                'Stress Assessment',
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

                        SizedBox(height: screenHeight * 0.04),

                        // Question card
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF141A24), // Slightly lighter than base color
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.06),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question
                              Text(
                                '5. How would you rate your stress level overall right now?',
                                style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.04),

                              // Emoji indicator
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return ScaleTransition(scale: animation, child: child);
                                },
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                    child: Text(
                                      _getEmoji(),
                                      key: ValueKey<int>(_stressLevel.round()),
                                      style: const TextStyle(
                                        fontSize: 72,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.03),

                              // Custom slider
                              SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 8,
                                  activeTrackColor: Colors.transparent,
                                  inactiveTrackColor: Colors.transparent,
                                  thumbColor: Colors.white,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 16,
                                    elevation: 4,
                                    pressedElevation: 8,
                                  ),
                                  overlayColor: gradientColors[1].withOpacity(0.2),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                                ),
                                child: Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.green.shade400,
                                        Colors.yellow.shade400,
                                        Colors.orange.shade400,
                                        Colors.red.shade400,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Slider(
                                    min: 1,
                                    max: 10,
                                    divisions: 9,
                                    value: _stressLevel,
                                    onChanged: (value) {
                                      setState(() {
                                        _stressLevel = value;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Labels
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Very Low',
                                    style: GoogleFonts.outfit(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Extremely High',
                                    style: GoogleFonts.outfit(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // Selected value indicator
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        colors: gradientColors,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: gradientColors[1].withOpacity(0.4),
                                          blurRadius: 16,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_stressLevel.round()}',
                                          style: GoogleFonts.outfit(
                                            textStyle: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '- ${_getLabel()}',
                                          style: GoogleFonts.outfit(
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Submit button
                        Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _isSubmitted
                                ? Container(
                              key: const ValueKey('submitted'),
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 32,
                              ),
                            )
                                : Container(
                              width: (screenWidth * 0.8).clamp(280.0, 320.0),
                              height: (52 * scaleFactor).clamp(45.0, 52.0),
                              child: ElevatedButton(
                                key: const ValueKey('submit'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: gradientColors[1],
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 6,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isSubmitted = true;
                                  });

                                  // Show feedback
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Stress level ${_stressLevel.round()} submitted!'),
                                      backgroundColor: gradientColors[1],
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );

                                  // Navigate after a short delay to show the checkmark animation
                                  Future.delayed(const Duration(milliseconds: 1000), () {
                                    if (mounted) {
                                      _navigateToNextScreen();
                                    }
                                  });
                                },
                                child: Text(
                                  'Submit',
                                  style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}