import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';
import 'package:mental_health/features/auth/data/models/auth/create_user_request.dart';
import 'package:mental_health/features/auth/domain/usecases/auth/signup.dart';
import 'package:mental_health/features/auth/presentation/auth/pages/signin.dart';
import 'package:mental_health/injections.dart';
import 'package:mental_health/presentation/homePage/home_page.dart';
import 'package:mental_health/resources/app_assets.dart';
import 'dart:ui';

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.1, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullname.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF080D13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF52EDC7),
            size: 22,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1CA47D).withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Image.asset(logo),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF080D13),
                  Color(0xFF0F1922),
                  Color(0xFF0A1D1A),
                ],
              ),
            ),
          ),

          // Background patterns
          Positioned.fill(
            child: CustomPaint(
              painter: SignupBackgroundPainter(),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),

                        // Main header
                        Text(
                          "Tune into your Mind",
                          style: TextStyle(
                            fontFamily: 't3',
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),

                        SizedBox(height: 12),

                        // Subtitle with gradient
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
                            'Register',
                            style: TextStyle(
                              fontFamily: 't1',
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        SizedBox(height: 50),

                        // Form fields in glass containers
                        _buildGlassInput(
                          icon: Icons.person_outline_rounded,
                          title: "FULL NAME",
                          controller: _fullname,
                          hint: "Enter your full name",
                        ),

                        SizedBox(height: 25),

                        _buildGlassInput(
                          icon: Icons.email_outlined,
                          title: "EMAIL",
                          controller: _email,
                          hint: "Enter your email address",
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: 25),

                        _buildGlassInput(
                          icon: Icons.lock_outline_rounded,
                          title: "PASSWORD",
                          controller: _password,
                          hint: "Create a password",
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onTogglePassword: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),

                        SizedBox(height: 60),

                        // Create Account button
                        Center(
                          child: _isLoading
                              ? _buildLoadingIndicator()
                              : _buildCreateAccountButton(context),
                        ),

                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Sign In bottom bar
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontFamily: 't2',
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
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
                        child: ShaderMask(
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
                            "Sign In",
                            style: TextStyle(
                              fontFamily: 't2',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassInput({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 't3',
              color: Color(0xFF1CA47D),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                obscureText: isPassword ? obscureText : false,
                obscuringCharacter: "●",
                keyboardType: keyboardType,
                style: TextStyle(
                  fontFamily: 't3',
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontFamily: 't3',
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    icon,
                    color: Color(0xFF1CA47D),
                    size: 22,
                  ),
                  suffixIcon: isPassword
                      ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.white.withOpacity(0.6),
                      size: 22,
                    ),
                    onPressed: onTogglePassword,
                  )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF52EDC7),
            Color(0xFF1CA47D),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1CA47D).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          if (_fullname.text.isEmpty || _email.text.isEmpty || _password.text.isEmpty) {
            _showErrorSnackbar(context, "Please fill in all fields");
            return;
          }

          setState(() {
            _isLoading = true;
          });

          try {
            var result = await sl<SignupUseCase>().call(
              params: CreateUserRequest(
                fullName: _fullname.text.toString(),
                email: _email.text.toString(),
                password: _password.text.toString(),
              ),
            );

            result.fold(
                  (error) {
                setState(() {
                  _isLoading = false;
                });
                _showErrorSnackbar(context, error);
              },
                  (success) {
                final mm = Hive.box('lastlogin');
                final first = Hive.box('firstime');
                mm.put("google", "false");
                first.put('firsttime', 'true');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false,
                );
              },
            );
          } catch (e) {
            setState(() {
              _isLoading = false;
            });
            _showErrorSnackbar(context, "An error occurred. Please try again.");
          }
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
          'Create Account',
          style: TextStyle(
            fontFamily: 't3',
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF52EDC7).withOpacity(0.7),
            Color(0xFF1CA47D).withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

// Custom painter for animated background
class SignupBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw small dots pattern
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 100; i++) {
      final double x = (i * 13) % size.width;
      final double y = (i * 17) % size.height;
      final double radius = 1 + (i % 3);

      canvas.drawCircle(Offset(x, y), radius, dotPaint);
    }

    // Draw subtle accent curves
    final curvePaint = Paint()
      ..color = Color(0xFF1CA47D).withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.75,
        size.width * 0.5, size.height * 0.85
    );
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.95,
        size.width, size.height * 0.8
    );
    canvas.drawPath(path, curvePaint);

    // Draw top corner accent
    final topAccentPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFF1CA47D).withOpacity(0.1),
          Color(0xFF1CA47D).withOpacity(0),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width * 0.5, size.height * 0.3));

    final topPath = Path();
    topPath.moveTo(0, 0);
    topPath.lineTo(size.width * 0.3, 0);
    topPath.lineTo(0, size.height * 0.3);
    topPath.close();

    canvas.drawPath(topPath, topAccentPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}