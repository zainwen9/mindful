import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/localDataProvider.dart';
import '../../resources/app_colors.dart';
import '../../widgets/animatedNavigator.dart';
import '../../widgets/customAlertDialogue.dart';
import '../chat_screen/chat_with_ai.dart';

// void main() {
//   runApp(const MaterialApp(home: FindingBuddyScreen()));
// }

class FindingBuddyScreen extends StatefulWidget {
  const FindingBuddyScreen({super.key});

  @override
  _FindingBuddyScreenState createState() => _FindingBuddyScreenState();
}

class _FindingBuddyScreenState extends State<FindingBuddyScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _expansionController;
  late Animation<double> _circleAnimation;
  bool _matched = false;

  @override
  void initState() {
    super.initState();
    getbudy();
    // Controller for the rotating circles (8 seconds per rotation)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();

    // Controller for the expanding circle animation
    _expansionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _expansionController,
        curve: Curves.easeOut,
      ),
    );

    _expansionController.forward();

    // Simulate finding a match after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final data =
            Provider.of<LocalDataProvider>(context, listen: false).buddies;
        if (data.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              pageBuilder: (_, __, ___) => const BuddyMatchedScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        } else {
          QuickAlert.show(
              type: QuickAlertType.info,
              headerBackgroundColor: const Color.fromARGB(255, 56, 53, 53),
              confirmBtnColor: const Color.fromARGB(255, 56, 53, 53),
              buttonFunction: () {
                AppNavigator.off();
              },
              title: "Buddy Not Found",
              subTitle: "Try again sometime later ");
        }
      }
    });
  }

  getbudy() async {
    final data = Provider.of<LocalDataProvider>(context, listen: false);

    await data.getBudies();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _expansionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),
                ),
                SizedBox(height: screenHeight * 0.1),
                Center(
                  child: Text(
                    "Finding your buddy...",
                    style: GoogleFonts.ubuntu(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),

                // Animated Circles with Mask
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    height: screenWidth * 0.8,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Rotating Dotted Circles
                        AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationController.value * 2 * pi,
                              child: CustomPaint(
                                size:
                                Size(screenWidth * 0.8, screenWidth * 0.8),
                                painter: DottedCirclesPainter(),
                              ),
                            );
                          },
                        ),

                        // Solid Circles with expanding mask
                        AnimatedBuilder(
                          animation: _circleAnimation,
                          builder: (context, child) {
                            return ClipPath(
                              clipper: CircleExpansionClipper(
                                  _circleAnimation.value),
                              child: CustomPaint(
                                size:
                                Size(screenWidth * 0.8, screenWidth * 0.8),
                                painter: SolidCirclesPainter(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.08),

                // Queue Text
                Center(
                  child: Column(
                    children: [
                      Text(
                        "In queue",
                        style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "We'll notify you when you're matched!",
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Start Chatting Button (disabled until matched)
            Positioned(
              bottom: 20,
              child: SizedBox(
                width: screenWidth * 0.9,
                child: ElevatedButton(
                  onPressed: _matched
                      ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatWithAi()),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF123225),
                    disabledBackgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Start Chatting",
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Colors.white,
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

class BuddyMatchedScreen extends StatefulWidget {
  const BuddyMatchedScreen({super.key});

  @override
  _BuddyMatchedScreenState createState() => _BuddyMatchedScreenState();
}

class _BuddyMatchedScreenState extends State<BuddyMatchedScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final budie = Provider.of<LocalDataProvider>(context, listen: true).buddies;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            alignment: Alignment.center, // Ensure the entire stack is centered
            children: [
              Column(
                mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
                children: [
                  SizedBox(height: screenHeight * 0.1),

                  // Header Text
                  Text(
                    "Buddy matched!",
                    style: GoogleFonts.ubuntu(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Centered Stack for Circles + Avatar + Name
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      height: screenWidth * 0.8,
                      child: Stack(
                        alignment: Alignment
                            .center, // Center all children in the stack
                        children: [
                          // Rotating Dotted Circles
                          AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotationController.value * 2 * pi,
                                child: CustomPaint(
                                  size: Size(
                                      screenWidth * 0.8, screenWidth * 0.8),
                                  painter: DottedCirclesPainter(),
                                ),
                              );
                            },
                          ),

                          // Solid Circles (fully visible now)
                          CustomPaint(
                            size: Size(screenWidth * 0.8, screenWidth * 0.8),
                            painter: SolidCirclesPainter(),
                          ),

                          // Profile Image & Name
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: screenHeight * 0.05,
                              ),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[800],
                                ),

                                width: 75, // Adjust size to fit within circles
                                height: 75,
                                child: budie[0]['image'] != ""
                                    ? Center(
                                  child: Image.network(
                                    budie[0]['image'],
                                    fit: BoxFit.fill,
                                  ),
                                )
                                    : Text(
                                  budie[0]['name'].toString(0, 1),
                                  style: TextStyle(
                                    color: ColorManager.bubbleColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                budie[0]['name'],
                                style: GoogleFonts.ubuntu(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  // Matching Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "You both are quitting sports betting,\nstruggle most in evenings and similar age range.",
                      style: GoogleFonts.ubuntu(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              // Start Chatting Button (positioned at the bottom)
              Positioned(
                bottom: 20,
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to chat screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03C390),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Start Chatting",
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleExpansionClipper extends CustomClipper<Path> {
  final double progress;

  CircleExpansionClipper(this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = size.width / 2 * progress;
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    ));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class DottedCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF03C390)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    _drawDottedCircle(canvas, centerX, centerY, size.width * 0.15, paint);
    _drawDottedCircle(canvas, centerX, centerY, size.width * 0.3, paint);
    _drawDottedCircle(canvas, centerX, centerY, size.width * 0.45, paint);
  }

  void _drawDottedCircle(
      Canvas canvas, double cx, double cy, double radius, Paint paint) {
    const double dashLength = 6;
    const double gapLength = 4;
    double circumference = 2 * pi * radius;
    int totalDashes = (circumference / (dashLength + gapLength)).floor();

    for (int i = 0; i < totalDashes; i++) {
      double angle1 = (i * (dashLength + gapLength)) / radius;
      double angle2 = ((i * (dashLength + gapLength)) + dashLength) / radius;

      Offset start =
      Offset(cx + radius * cos(angle1), cy + radius * sin(angle1));
      Offset end = Offset(cx + radius * cos(angle2), cy + radius * sin(angle2));

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SolidCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF03C390)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.15, paint);
    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.3, paint);
    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.45, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
