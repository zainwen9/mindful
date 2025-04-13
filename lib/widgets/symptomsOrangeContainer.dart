import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../resources/app_colors.dart';
import '../resources/text_styles.dart';


class symptomsOrangeContainer extends StatelessWidget {
  const symptomsOrangeContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0, bottom: 24.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ColorManager.orange, // Orange color
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        'Neglecting your mental health can affect your emotional, social, and overall well-being — taking care of your mind is just as important as your body.',
        style: GoogleFonts.outfit(
          textStyle:orangeContainerText,
        ),
      ),
    );
  }
}