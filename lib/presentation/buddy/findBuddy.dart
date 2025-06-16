import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../resources/app_colors.dart';
import '../../resources/dimensions.dart';
import '../../resources/text_styles.dart';
import 'findingABuddyScreen.dart';

class FindABuddy extends StatelessWidget {
  const FindABuddy({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1C1C),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.05,
        horizontal: screenWidth * 0.05,
      ), // Consistent padding
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start, // Align all children to the start (left)
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Accountability Buddy",
                style: GoogleFonts.ubuntu(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.white,
                ),
              ),
              // Image.asset(
              //   fist,
              //   height: screenWidth * 0.12,
              //   width: screenWidth * 0.12,
              // ),
            ],
          ),
          SizedBox(
              height:
              screenWidth * 0.02), // Spacing between title and description
          RichText(
            textAlign: TextAlign.left, // Align text to the left
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Find a partner to boost your quitting\npower. ",
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
                TextSpan(
                  text: "80% more likely to succeed.",
                  style: GoogleFonts.ubuntu(
                    textStyle: TextStyle(
                      color: ColorManager.white,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              height:
              screenWidth * 0.04), // Spacing between description and button
          Center(
            // Center the button horizontally
            child: Padding(
              padding: EdgeInsets.only(bottom: screenWidth * 0.03),
              child: AnimatedAppTealButton(
                text: 'Find a Buddy',
                onPressed: () {
                  // final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
                  // if (homeScreenState != null) {
                  //   homeScreenState._findBuddy();
                  // }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FindingBuddyScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class AnimatedAppTealButton extends StatefulWidget {
  final String text;
  final double height;
  final double width;
  final double fontSize;
  final bool showIcon;
  final VoidCallback onPressed;

  const AnimatedAppTealButton({
    super.key,
    required this.text,
    this.height = 52,
    this.width = 340,
    this.fontSize = 14,
    this.showIcon = false,
    required this.onPressed,
  });

  @override
  State<AnimatedAppTealButton> createState() => _AnimatedAppTealButtonState();
}

class _AnimatedAppTealButtonState extends State<AnimatedAppTealButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fontSizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fontSizeAnimation = Tween<double>(
      begin: widget.fontSize,
      end: widget.fontSize * 0.875, // 14pt when original is 16pt (16 * 0.875 = 14)
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateButton() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse().then((_) => widget.onPressed()),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: ColorManager.bubbleColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.text,
                    style: GoogleFonts.figtree(
                      textStyle: buttonTextStyle.copyWith(
                        fontSize: _fontSizeAnimation.value,
                      ),
                    ),
                  ),
                  if (widget.showIcon) ...[
                    SizedBox(width: AppSize.s12),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: ColorManager.white,
                      size: AppSize.s20 * _scaleAnimation.value, // Scale icon too
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}