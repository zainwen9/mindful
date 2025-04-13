import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_health/presentation/onboarding/onboarding.dart';
import 'package:mental_health/resources/app_colors.dart';
import 'dart:ui';

class questionEight extends StatefulWidget {
  @override
  _questionEightState createState() => _questionEightState();
}

class _questionEightState extends State<questionEight> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isFocused = false;
  bool _hasText = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });

    // Start the entrance animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSubmission() {
    // Show SnackBar and navigate to next page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _hasText ? "Your additional thoughts have been saved!" : "Skipping this question",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        backgroundColor: ColorManager.bubbleColor,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ).closed.then((_) {
      // Navigate to jbdcihjbdkjadb screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Onboarding()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Custom background color
    final backgroundColor = Color(0xFF080D13);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: Stack(
          children: [
            // Background design elements
            Positioned(
              top: -150,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      ColorManager.bubbleColor.withOpacity(0.3),
                      ColorManager.bubbleColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      ColorManager.bubbleColor.withOpacity(0.2),
                      ColorManager.bubbleColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Animated title appearance
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, -0.2),
                            end: Offset.zero,
                          ).animate(_animationController),
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors.white,
                                ColorManager.bubbleColor,
                                ColorManager.bubbleColor.withBlue(
                                  (ColorManager.bubbleColor.blue + 40).clamp(0, 255),
                                ),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: Text(
                              "Final Thoughts",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.5,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Animated subtitle
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(0.2, 1.0, curve: Curves.easeOut),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF1A2235).withOpacity(0.5),
                                  Color(0xFF1A2235).withOpacity(0.3),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Text(
                              "Optional • Feel free to share anything else",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),

                      // Question box with animated appearance
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Container(
                            padding: EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF121821),
                                  Color(0xFF1A2235),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: Offset(5, 5),
                                ),
                                BoxShadow(
                                  color: ColorManager.bubbleColor.withOpacity(0.15),
                                  blurRadius: 15,
                                  offset: Offset(-3, -3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Question header
                                Row(
                                  children: [
                                    // Question number with animated pulse
                                    TweenAnimationBuilder<double>(
                                      duration: Duration(seconds: 2),
                                      tween: Tween<double>(begin: 0.95, end: 1.05),
                                      builder: (context, value, child) {
                                        return Transform.scale(
                                          scale: value,
                                          child: child,
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              ColorManager.bubbleColor,
                                              ColorManager.bubbleColor.withOpacity(0.7),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorManager.bubbleColor.withOpacity(0.4),
                                              blurRadius: 8,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "8",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        "Is there anything else you'd like to share?",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),

                                // Enhanced text field with glass effect
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _isFocused
                                          ? ColorManager.bubbleColor
                                          : Colors.white.withOpacity(0.15),
                                      width: 1.5,
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(_isFocused ? 0.3 : 0.1),
                                        Colors.black.withOpacity(_isFocused ? 0.2 : 0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: _isFocused ? [
                                      BoxShadow(
                                        color: ColorManager.bubbleColor.withOpacity(0.2),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                      ),
                                    ] : [],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextField(
                                          controller: _controller,
                                          focusNode: _focusNode,
                                          maxLines: null,
                                          expands: true,
                                          textAlignVertical: TextAlignVertical.top,
                                          cursorColor: ColorManager.bubbleColor,
                                          cursorWidth: 2,
                                          cursorRadius: Radius.circular(2),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 0.5,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Share any additional thoughts or feelings here...",
                                            hintStyle: TextStyle(
                                              color: Colors.white.withOpacity(0.4),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.all(16),
                                          ),
                                          keyboardType: TextInputType.multiline,
                                          onChanged: (text) {
                                            setState(() {
                                              _hasText = text.isNotEmpty;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),

                                // Optional text indicator
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Optional",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                                // Character count
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: AnimatedBuilder(
                                    animation: _controller,
                                    builder: (context, child) {
                                      return Text(
                                        "${_controller.text.length} characters",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 14,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Helper text with animation
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(0.3, 1.0, curve: Curves.easeOut),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF1E293B).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Your responses help us understand your needs better. Feel free to skip this question.",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),

                      // Continue/Skip button with animation
                      Center(
                        child: GestureDetector(
                          onTap: _handleSubmission,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 300),
                              tween: Tween<double>(begin: 1.0, end: _hasText ? 1.05 : 1.0),
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: child,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      ColorManager.bubbleColor,
                                      _hasText
                                          ? ColorManager.bubbleColor.withBlue(
                                        (ColorManager.bubbleColor.blue + 30).clamp(0, 255),
                                      )
                                          : ColorManager.bubbleColor.withOpacity(0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorManager.bubbleColor.withOpacity(0.5),
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                      spreadRadius: -5,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _hasText ? "Continue" : "Skip & Continue",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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