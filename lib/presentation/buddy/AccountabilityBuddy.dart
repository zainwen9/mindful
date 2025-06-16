import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_health/presentation/buddy/supportHub.dart';
import 'package:mental_health/widgets/appGreenButton.dart';
import '../../resources/app_colors.dart'; // Reusing your AppTealButton widget

class YourAccountabilityBuddy extends StatelessWidget {
  const YourAccountabilityBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenWidth * 0.03,
      ), // Responsive padding
      decoration: BoxDecoration(
        color: const Color(0xFF0F1C1C), // Same background color as your example
        borderRadius: BorderRadius.circular(24), // Rounded corners on all sides
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Your Accountability Buddy",
            style: GoogleFonts.ubuntu(
              fontSize: screenWidth * 0.045, // Adjust text size dynamically
              fontWeight: FontWeight.bold,
              color: ColorManager.white, // Using your ColorManager
            ),
          ),
          SizedBox(height: screenWidth * 0.03), // Spacing
          // Buddy Info Row
          Row(
            children: [
              // Image.asset(josh),
              SizedBox(width: screenWidth * 0.03), // Spacing
              // Name and Last Check-In
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Josh",
                    style: GoogleFonts.ubuntu(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w500,
                      color: ColorManager.white,
                    ),
                  ),
                  Text(
                    "Last check-in: 28 hours ago",
                    style: GoogleFonts.ubuntu(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.04), // Spacing
          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Message Josh Button
              Expanded(
                child: AppGreenButton(
                  text: 'Message Josh',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SupportHubScreen(showCheckIn: false),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: screenWidth * 0.03), // Spacing between buttons
              // Daily Check-In Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const SupportHubScreen(showCheckIn: true),
                    //   ),
                    // );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[600]!), // Border color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.03,
                    ),
                  ),
                  child: Text(
                    "Daily Check-In",
                    style: GoogleFonts.ubuntu(
                      fontSize: screenWidth * 0.04,
                      color: ColorManager.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}