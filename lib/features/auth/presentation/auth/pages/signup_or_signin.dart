import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mental_health/features/auth/presentation/auth/pages/signin.dart';
import 'package:mental_health/features/auth/presentation/auth/pages/signup.dart';
import 'package:mental_health/resources/app_assets.dart';
import 'dart:ui';

class SignupOrSignin extends StatefulWidget {
  const SignupOrSignin({super.key});

  @override
  State<SignupOrSignin> createState() => _SignupOrSigninState();
}

class _SignupOrSigninState extends State<SignupOrSignin> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Dark gradient background with theme color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF080D13),  // Your theme color
                  Color(0xFF0F1922),  // Slightly lighter shade
                  Color(0xFF0A1D1A),  // Dark green-tinted shade
                ],
              ),
            ),
          ),

          // Animated pattern overlay
          Positioned.fill(
            child: CustomPaint(
              painter: NightSkyPainter(),
            ),
          ),

          // Animated glowing accent lines
          Positioned.fill(
            child: CustomPaint(
              painter: GlowingLinesPainter(),
            ),
          ),

          // Logo at top right with glow effect
          Positioned(
            top: 30,
            right: 30,
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1CA47D).withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                logo,
                height: 56,
                width: 56,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenSize.height * 0.12),

                  // Main content with animation
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Main logo in center
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF1CA47D).withOpacity(0.2),
                                    blurRadius: 25,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Image.asset(logo),
                            ),

                            SizedBox(height: 30),

                            // Header text with green gradient
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [
                                    Color(0xFF52EDC7),
                                    Color(0xFF1CA47D),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: Text(
                                "Let's clear your mind",
                                style: TextStyle(
                                  fontFamily: 't3',
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height: 18),

                            // Subtitle
                            Text(
                              "Mindful - One Step Ahead",
                              style: TextStyle(
                                fontFamily: 't3',
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 18,
                                letterSpacing: 0.8,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 40),

                            // Description in glass-like container
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color(0xFF1CA47D).withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF1CA47D).withOpacity(0.05),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    "Mindful does everything you ever wished for from making you relaxed to give you future motivation",
                                    style: TextStyle(
                                      fontFamily: 't3',
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16,
                                      height: 1.6,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Buttons
                  FadeTransition(
                    opacity: _fadeInAnimation,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          // Register button
                          Container(
                            height: 60,
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF1CA47D).withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF52EDC7),
                                  Color(0xFF1CA47D),
                                ],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => Signup(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      var curve = Curves.easeOutCubic;
                                      var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
                                      return FadeTransition(
                                        opacity: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontFamily: 't3',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),

                          // Sign In button
                          Container(
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Color(0xFF1CA47D).withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => SignIn(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      var curve = Curves.easeOutCubic;
                                      var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
                                      return FadeTransition(
                                        opacity: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.transparent),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 't3',
                                  color: Color(0xFF52EDC7),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for star-like pattern
class NightSkyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw stars/particles
    final random = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 50; i++) {
      final double x = ((random + i * 7) % 97) / 97 * size.width;
      final double y = ((random + i * 13) % 91) / 91 * size.height;
      final double radius = 1 + (i % 3);

      final starPaint = Paint()
        ..color = i % 5 == 0
            ? Color(0xFF52EDC7).withOpacity(0.3)
            : Colors.white.withOpacity(0.1 + (i % 7) / 70);

      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for glowing accent lines
class GlowingLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create gradient shader for lines
    final greenGradient = LinearGradient(
      colors: [
        Color(0xFF1CA47D).withOpacity(0),
        Color(0xFF1CA47D).withOpacity(0.3),
        Color(0xFF52EDC7).withOpacity(0.2),
        Color(0xFF1CA47D).withOpacity(0),
      ],
      stops: [0.0, 0.3, 0.7, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw accent line 1
    final line1Paint = Paint()
      ..shader = greenGradient
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.7);
    path1.quadraticBezierTo(
        size.width * 0.5, size.height * 0.65,
        size.width, size.height * 0.75
    );
    canvas.drawPath(path1, line1Paint);

    // Draw accent line 2
    final line2Paint = Paint()
      ..shader = greenGradient
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path2 = Path();
    path2.moveTo(size.width * 0.1, size.height * 0.2);
    path2.quadraticBezierTo(
        size.width * 0.4, size.height * 0.3,
        size.width * 0.3, size.height * 0.45
    );
    canvas.drawPath(path2, line2Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}