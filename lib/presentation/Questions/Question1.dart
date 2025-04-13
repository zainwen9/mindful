import 'package:flutter/material.dart';
import 'package:mental_health/resources/app_colors.dart';

import 'Question2.dart';

class question1 extends StatefulWidget {
  @override
  _question1State createState() => _question1State();
}

class _question1State extends State<question1> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmission() {
    // Show SnackBar and navigate to Page2
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Your response has been saved!",
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => questionTwo(),),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with Gradient
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, ColorManager.bubbleColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  "Reflect on Your Emotions",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Subtitle with subtle opacity
              Text(
                "How have you been feeling emotionally in the past few days?",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 40),
              // Multiline TextField with Enhanced Design
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.shade900,
                        Colors.grey.shade800.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: Offset(4, 4),
                      ),
                      BoxShadow(
                        color: ColorManager.bubbleColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(-4, -4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: "Share your feelings here...",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(24),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    style: TextStyle(
                      color: Colors.white, // Improved contrast
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    cursorColor: ColorManager.bubbleColor,
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Submit Button with Animation
              Center(
                child: GestureDetector(
                  onTap: _handleSubmission,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorManager.bubbleColor,
                          ColorManager.bubbleColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.bubbleColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
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