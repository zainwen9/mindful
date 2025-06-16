import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_health/presentation/buddy/supportHub.dart';
import '../../resources/app_colors.dart';
import '../community/community.dart';



class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final BuildContext context;

  const TabButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (title == "My Buddy") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SupportHubScreen()),
          );
        } else if (title == "Community") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CommunityScreen()),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? ColorManager.bubbleColor : Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        title,
        style: GoogleFonts.ubuntu(
          fontSize: 14,
          color: ColorManager.white,
        ),
      ),
    );
  }
}