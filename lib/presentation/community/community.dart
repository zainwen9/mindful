import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../resources/app_colors.dart';
import '../buddy/TabButton.dart';
import 'communityChat.dart';


class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Support Hub',
                style: GoogleFonts.ubuntu(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Tabs
              Wrap(
                spacing: 12,
                children: [
                  TabButton(title: 'My Buddy', isSelected: false, context: context),
                  TabButton(title: 'Community', isSelected: true, context: context),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // Community Card
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Icon

                    SizedBox(width: 12),

                    // Text Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Quitting Squat',
                            style: GoogleFonts.ubuntu(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'The urge hits, but so does the support. \nFind your strength in numbers here.',
                            style: GoogleFonts.ubuntu(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Chat Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CommunityChatScreen(),),);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0ABE57),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        'Chat',
                        style: GoogleFonts.ubuntu(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}