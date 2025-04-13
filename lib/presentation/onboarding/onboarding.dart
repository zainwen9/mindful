import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mental_health/features/auth/presentation/auth/pages/signup_or_signin.dart';
import 'dart:ui';
import 'dart:math';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;
  late AnimationController _pageTransitionController;
  late Animation<double> _pageTransitionAnimation;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'EchoMind',
      'subtitle': 'Improve your health, live better in all aspects, with one app!',
      'animation': "https://lottie.host/041fa715-ab55-4bde-802e-1e230e2f1dce/C4XLl7Dw0s.json",
      'themeColor': const Color(0xFF4FC3F7),
      'backgroundImage': 'assets/bg_pattern_blue.png',
      'highlightColor': const Color(0xFF01579B),
    },
    {
      'title': 'Most Powerful Integration',
      'subtitle': 'Suggestions like never before and analysis like a pro with LLAMA-8B-8192',
      'image': 'assets/llama.png',
      'themeColor': const Color(0xFF66BB6A),
      'backgroundImage': 'assets/bg_pattern_green.png',
      'highlightColor': const Color(0xFF2E7D32),
    },
    {
      'title': 'Powered by the Best',
      'subtitle': 'Fully secure transmission of vital information thanks to encrypted technologies',
      'images': ['assets/nodepress.png', 'assets/firebase.png', 'assets/postgres.png'],
      'themeColor': const Color(0xFFAB47BC),
      'backgroundImage': 'assets/bg_pattern_purple.png',
      'highlightColor': const Color(0xFF6A1B9A),
    },
  ];

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pageTransitionAnimation = CurvedAnimation(
      parent: _pageTransitionController,
      curve: Curves.easeInOut,
    );
  }

  void _goToNextPage() {
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });

    if (_currentPage < _totalPages - 1) {
      _pageTransitionController.forward().then((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
        _pageTransitionController.reset();
      });
    } else {
      _navigateToSignupOrSignin();
    }
  }

  void _navigateToSignupOrSignin() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SignupOrSignin(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Background Layer
          _buildBackgroundLayer(),

          // Content Layer
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _totalPages,
            itemBuilder: (context, index) => _buildPage(index, size),
          ),

          // Bottom Controls Layer
          _buildBottomControls(size),

          // Top Skip Button Layer
          _buildSkipButton(),
        ],
      ),
    );
  }

  Widget _buildBackgroundLayer() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: Container(
        key: ValueKey<int>(_currentPage),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_onboardingData[_currentPage]['backgroundImage']),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _onboardingData[_currentPage]['themeColor'].withOpacity(0.8),
              _onboardingData[_currentPage]['themeColor'].withOpacity(0.4),
              _onboardingData[_currentPage]['themeColor'].withOpacity(0.2),
              Colors.white.withOpacity(0.9),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index, Size size) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.08),
          // Title with creative animation
          _buildPageTitle(index),

          SizedBox(height: size.height * 0.02),

          // Main content area
          Expanded(
            child: _buildPageContent(index, size),
          ),

          // Subtitle with card design
          _buildSubtitleCard(index),

          SizedBox(height: size.height * 0.12),
        ],
      ),
    );
  }

  Widget _buildPageTitle(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Hero(
        tag: 'page_title_$index',
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Small label above main title
              Text(
                index == 0 ? 'WELCOME TO' : (index == 1 ? 'EXPERIENCE' : 'SECURITY'),
                style: TextStyle(
                  fontFamily: 't3',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                  color: _onboardingData[index]['highlightColor'],
                ),
              ),
              const SizedBox(height: 8),
              // Main title with highlight effect
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    _onboardingData[index]['themeColor'],
                    _onboardingData[index]['highlightColor'],
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  _onboardingData[index]['title'],
                  style: TextStyle(
                    fontFamily: index == 0 ? 't2' : 't1',
                    fontSize: index == 0 ? 70 : 48,
                    fontWeight: FontWeight.bold,
                    height: 0.9,
                    color: Colors.white, // This color will be affected by the shader
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(int index, Size size) {
    switch (index) {
      case 0:
      // First page with parallax animation effect
        return Stack(
          alignment: Alignment.center,
          children: [
            // Atmospheric particles as a Stack instead of returning a list
            ..._buildParticleEffect(size),

            // Main animation with enhanced container
            Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _onboardingData[index]['themeColor'].withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: LottieBuilder.network(
                        _onboardingData[index]['animation'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

      case 1:
      // Second page with 3D-like floating effect
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background glow
            Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _onboardingData[index]['themeColor'].withOpacity(0.4),
                    _onboardingData[index]['themeColor'].withOpacity(0.0),
                  ],
                ),
              ),
            ),

            // Floating image with reflection
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, sin(DateTime.now().millisecondsSinceEpoch * 0.0005) * 10),
                  child: child,
                );
              },
              child: Container(
                height: size.height * 0.4,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: _onboardingData[index]['themeColor'].withOpacity(0.5),
                      blurRadius: 40,
                      spreadRadius: 5,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    children: [
                      // Main image
                      Image.asset(
                        _onboardingData[index]['image'],
                        fit: BoxFit.contain,
                      ),

                      // Reflection overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.2),
                              ],
                              stops: const [0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Decorative tech elements
            ..._buildFloatingTechIcons(size, index),
          ],
        );

      case 2:
      // Third page with orbital tech icons
        return Stack(
          alignment: Alignment.center,
          children: [
            // Central glow
            Container(
              width: size.width * 0.4,
              height: size.width * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _onboardingData[index]['themeColor'].withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 20,
                  ),
                ],
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _onboardingData[index]['themeColor'].withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: _onboardingData[index]['themeColor'].withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.security,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),

            // Orbital tech icons with animation
            ..._buildOrbitalTechIcons(index, size),

            // Connection lines
            CustomPaint(
              size: Size(size.width * 0.8, size.height * 0.5),
              painter: ConnectionPainter(
                color: _onboardingData[index]['themeColor'].withOpacity(0.3),
              ),
            ),
          ],
        );

      default:
        return Container();
    }
  }

  List<Widget> _buildParticleEffect(Size size) {
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(
      15,
          (i) => Positioned(
        left: (random % (i + 1) * 127) % size.width,
        top: (random % (i + 2) * 163) % (size.height * 0.6),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(seconds: 2 + i % 3),
          builder: (context, double value, child) {
            return Opacity(
              opacity: 0.5 - 0.3 * sin(value * 6.28),
              child: Transform.translate(
                offset: Offset(
                  sin(value * 6.28 + i) * 15,
                  cos(value * 6.28 + i) * 15,
                ),
                child: child,
              ),
            );
          },
          child: Container(
            width: 8 + (i % 10),
            height: 8 + (i % 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _onboardingData[_currentPage]['themeColor'].withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingTechIcons(Size size, int index) {
    final iconData = [
      Icons.api,
      Icons.memory,
      Icons.psychology,
      Icons.auto_graph,
    ];

    return List.generate(
      iconData.length,
          (i) => Positioned(
        left: (i * 57 + 20) % (size.width - 40),
        top: (i * 83 + 50) % (size.height * 0.4),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(seconds: 3 + i),
          builder: (context, double value, child) {
            return Opacity(
              opacity: 0.7,
              child: Transform.translate(
                offset: Offset(
                  sin(value * 3.14 + i) * 15,
                  cos(value * 3.14 + i) * 15,
                ),
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: _onboardingData[index]['themeColor'].withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              iconData[i],
              color: _onboardingData[index]['themeColor'],
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOrbitalTechIcons(int index, Size size) {
    final orbitalPositions = [
      [size.width * 0.3, size.height * 0.15, 1.0],  // [x, y, scale]
      [size.width * 0.75, size.height * 0.25, 1.2],
      [size.width * 0.7, size.height * 0.4, 0.9],
    ];

    return List.generate(
      _onboardingData[index]['images'].length,
          (i) => TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: 20 + i * 5),
        builder: (context, double value, child) {
          final angle = value * 2 * 3.14 + (i * 2.09);
          final radius = size.width * 0.25;
          final x = size.width / 2 + cos(angle) * radius;
          final y = size.height * 0.25 + sin(angle) * radius;

          return Positioned(
            left: x - (orbitalPositions[i][2] as double) * 50,
            top: y - (orbitalPositions[i][2] as double) * 50,
            child: Transform.rotate(
              angle: angle + 3.14 / 4,
              child: child,
            ),
          );
        },
        child: Container(
          width: (orbitalPositions[i][2] as double) * 100,
          height: (orbitalPositions[i][2] as double) * 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: _onboardingData[index]['themeColor'].withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: Image.asset(
            _onboardingData[index]['images'][i],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitleCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.9, end: 1.0),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: _onboardingData[index]['themeColor'].withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    index == 0 ? Icons.favorite : (index == 1 ? Icons.psychology : Icons.security),
                    color: _onboardingData[index]['themeColor'],
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    index == 0 ? 'SELF CARE' : (index == 1 ? 'AI POWERED' : 'SECURE'),
                    style: TextStyle(
                      fontFamily: 't3',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: _onboardingData[index]['themeColor'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _onboardingData[index]['subtitle'],
                style: TextStyle(
                  fontFamily: 't3',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls(Size size) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Progress indicator
            Row(
              children: List.generate(
                _totalPages,
                    (index) => _buildPageIndicator(index),
              ),
            ),

            // Next/Finish button with animation
            GestureDetector(
              onTap: _goToNextPage,
              child: ScaleTransition(
                scale: _buttonScaleAnimation,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        colors: [
                          _onboardingData[_currentPage]['themeColor'],
                          _onboardingData[_currentPage]['highlightColor'],
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _onboardingData[_currentPage]['themeColor'].withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          _currentPage == _totalPages - 1 ? "Get Started" : "Next",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 't3',
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
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
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    bool isActive = index == _currentPage;

    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: isActive ? 12 : 8,
        width: isActive ? 30 : 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isActive
              ? _onboardingData[_currentPage]['themeColor']
              : _onboardingData[_currentPage]['themeColor'].withOpacity(0.3),
          boxShadow: isActive ? [
            BoxShadow(
              color: _onboardingData[_currentPage]['themeColor'].withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ] : null,
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 25,
      child: GestureDetector(
        onTap: _navigateToSignupOrSignin,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Skip",
                style: TextStyle(
                  fontFamily: 't3',
                  color: _onboardingData[_currentPage]['themeColor'],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.skip_next_rounded,
                color: _onboardingData[_currentPage]['themeColor'],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonAnimationController.dispose();
    _pageTransitionController.dispose();
    super.dispose();
  }
}

class ConnectionPainter extends CustomPainter {
  final Color color;
  ConnectionPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw connecting lines between center and orbital points
    for (int i = 0; i < 3; i++) {
      final angle = i * 2.09;
      final radius = size.width * 0.25;
      final x = center.dx + cos(angle) * radius;
      final y = center.dy + sin(angle) * radius;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(x, y);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}