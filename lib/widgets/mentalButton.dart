import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../resources/app_colors.dart';


class mentalButton extends StatelessWidget {
  final String text;
  const mentalButton({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.mentalButton, // Olive green
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          elevation: 0,
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
