import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../resources/app_colors.dart';
import '../resources/text_styles.dart';


class AppGreenButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final double fontSize;
  final bool showIcon;
  final VoidCallback onPressed;

  const AppGreenButton({
    super.key,
    required this.text,
    this.height = 57,
    this.width = 227,
    this.fontSize = 16,
    this.showIcon = true, // Default: show icon
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Makes button clickable
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: ColorManager.bubbleColor,
          borderRadius: BorderRadius.circular(58),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: GoogleFonts.figtree(
                textStyle: buttonTextStyle.copyWith(fontSize: fontSize),
              ),
            ),

          ],
        ),
      ),
    );
  }
}