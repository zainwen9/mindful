import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';
import 'package:mental_health/features/auth/data/models/auth/signin_user_req.dart';
import 'package:mental_health/features/auth/domain/entities/auth/googleapisignin.dart';
import 'package:mental_health/features/auth/domain/usecases/auth/signin.dart';
import 'package:mental_health/features/auth/presentation/auth/pages/signup.dart';
import 'package:mental_health/injections.dart';
import 'package:mental_health/presentation/homePage/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mental_health/resources/app_assets.dart';
import 'dart:ui';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
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
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future signIn() async {
      final user = await GoogleSignInApi.login();
      final myboxx = Hive.box('lastlogin');
      final first = Hive.box('firstime');
      if (user == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Cancelled by User")));
      } else {
        myboxx.put('google', 'true');
        first.put('firsttime', 'true');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                (route) => false);
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF080D13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              painter: SignInBackgroundPainter(),
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
                        Text(
                          "Get In Your Mood",
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
                            'Sign In',
                            style: TextStyle(
                              fontFamily: 't1',
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        SizedBox(height: 70),

                        // Form fields in glass containers
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
                          hint: "Enter your password",
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onTogglePassword: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),

                        SizedBox(height: 50),

                        // Login button
                        Center(
                          child: _isLoading
                              ? _buildLoadingIndicator()
                              : _buildSignInButton(context),
                        ),

                        SizedBox(height: 40),

                        // Or continue with divider
                        _buildOrDivider(),

                        SizedBox(height: 30),

                        // Google sign in button
                        _buildGoogleSignInButton(onPressed: signIn),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Sign Up bottom bar
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
                        'Not A Member?',
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
                            "Register Now",
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

  Widget _buildSignInButton(BuildContext context) {
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
          if (_email.text.isEmpty || _password.text.isEmpty) {
            _showErrorSnackbar(context, "Please fill in all fields");
            return;
          }

          setState(() {
            _isLoading = true;
          });

          try {
            var result = await sl<SigninUseCase>().call(
              params: SigninUserReq(
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
                final my = Hive.box('lastlogin');
                my.put("google", "false");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => HomePage()),
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
          'Sign In',
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

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "OR",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton({required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
          ),
          child: FaIcon(
            FontAwesomeIcons.google,
            color: Colors.red,
            size: 16,
          ),
        ),
        label: Text(
          "Continue with Google",
          style: TextStyle(
            fontFamily: 't3',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
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
class SignInBackgroundPainter extends CustomPainter {
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
    path.moveTo(0, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.55,
        size.width * 0.5, size.height * 0.65
    );
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.75,
        size.width, size.height * 0.6
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