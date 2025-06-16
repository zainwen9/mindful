import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_health/widgets/appGreenButton.dart';
import '../../resources/app_colors.dart';
import 'ChatScreen.dart';
import 'TabButton.dart';
import 'findingABuddyScreen.dart';

class SupportHubScreen extends StatefulWidget {
  final bool showCheckIn;

  const SupportHubScreen({super.key, this.showCheckIn = false});

  @override
  State<SupportHubScreen> createState() => _SupportHubScreenState();
}

class _SupportHubScreenState extends State<SupportHubScreen> {
  int _selectedIndex = 3;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (widget.showCheckIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDailyCheckInBottomSheet(context);
      });
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => HomeScreen()),
                        // );
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.white,
                        size: screenWidth * 0.06,
                      ),
                    ),
                    Text(
                      'Support Hub',
                      style: GoogleFonts.ubuntu(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Wrap(
                  spacing: screenWidth * 0.03,
                  children: [
                    TabButton(
                        title: 'My Buddy', isSelected: true, context: context),
                    TabButton(
                        title: 'Community',
                        isSelected: false,
                        context: context),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: const Color(0xFF03C390).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(screenWidth * 0.06),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //   fistBig,
                      //   width: screenWidth * 0.3,
                      //   height: screenWidth * 0.3,
                      // ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Accountability Buddy System',
                        style: GoogleFonts.ubuntu(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      _buildListItem(
                        Icons.person_outline,
                        'Get matched with another quitter',
                        screenWidth,
                      ),
                      _buildListItem(
                        Icons.check_circle_outline,
                        'Check in with each other daily',
                        screenWidth,
                      ),
                      _buildListItem(
                        Icons.chat_bubble_outline,
                        'Private 1 on 1 conversations',
                        screenWidth,
                      ),
                      _buildListItem(
                        Icons.star_border,
                        '80% higher success rate for reaching your goals',
                        screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      AppGreenButton(
                        text: 'Find A Buddy',
                        onPressed: () {
                          _showBuddyQueueBottomSheet(context);
                        },
                        fontSize: screenWidth * 0.04,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
      } else {}
    });
  }

  Widget _buildListItem(IconData icon, String text, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        children: [
          Icon(
            icon,
            color: ColorManager.teal,
            size: screenWidth * 0.05,
          ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.ubuntu(
                fontSize: screenWidth * 0.04,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDailyCheckInBottomSheet(BuildContext context) {
    int selectedEmojiIndex = 2;
    bool isBetFree = true;
    final TextEditingController controller = TextEditingController();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(screenWidth * 0.06)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A2A2A), Color(0xFF0F1C1C)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Check-In',
                          style: GoogleFonts.ubuntu(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: screenWidth * 0.06,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'How are you feeling?',
                        style: GoogleFonts.ubuntu(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(screenWidth * 0.08),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          final emojis = ['😢', '😕', '😐', '😊', '😂'];
                          return GestureDetector(
                            onTap: () =>
                                setState(() => selectedEmojiIndex = index),
                            child: CircleAvatar(
                              radius: screenWidth * 0.06,
                              backgroundColor: selectedEmojiIndex == index
                                  ? Colors.white
                                  : Colors.transparent,
                              child: Text(
                                emojis[index],
                                style: TextStyle(fontSize: screenWidth * 0.08),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Bet-Free today?',
                        style: GoogleFonts.ubuntu(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(screenWidth * 0.08),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isBetFree = true),
                              child: Container(
                                height: screenHeight * 0.07,
                                decoration: BoxDecoration(
                                  color: isBetFree
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius:
                                  BorderRadius.circular(screenWidth * 0.08),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Yes',
                                  style: GoogleFonts.ubuntu(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                    color:
                                    isBetFree ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isBetFree = false),
                              child: Container(
                                height: screenHeight * 0.07,
                                decoration: BoxDecoration(
                                  color: !isBetFree
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius:
                                  BorderRadius.circular(screenWidth * 0.08),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'No',
                                  style: GoogleFonts.ubuntu(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                    color: !isBetFree
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Any urges or triggers today?',
                        style: GoogleFonts.ubuntu(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    TextField(
                      controller: controller,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                      ),
                      decoration: InputDecoration(
                        hintText: '  Type Here...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.04,
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(screenWidth * 0.08),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(screenWidth * 0.06),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015),
                            ),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.ubuntu(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: AppGreenButton(
                            text: 'Submit',
                            onPressed: () {
                              // Map the emoji index to a description
                              final emojiDescriptions = [
                                'Sad',
                                'Unhappy',
                                'Neutral',
                                'Good',
                                'Great'
                              ];
                              final selectedEmoji = [
                                '😢',
                                '😕',
                                '😐',
                                '😊',
                                '😂'
                              ][selectedEmojiIndex];
                              final feeling =
                              emojiDescriptions[selectedEmojiIndex];
                              final betStatus =
                              isBetFree ? 'Bet-Free' : 'Not Bet-Free';
                              final trigger = controller.text.trim().isEmpty
                                  ? 'None'
                                  : controller.text.trim();

                              // Navigate to ChatScreen and pass the data
                              Navigator.pop(context); // Close the bottom sheet
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    initialMessage:
                                    'Daily Check-In $selectedEmoji $feeling! $betStatus $trigger',
                                  ),
                                ),
                              );
                            },
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBuddyQueueBottomSheet(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(screenWidth * 0.06)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Color(0xFF12161C),
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(screenWidth * 0.06)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CircleAvatar(
                  //   radius: screenWidth * 0.1,
                  //   backgroundColor: Colors.transparent,
                  //   child: Image.asset(
                  //     fistBig,
                  //     width: screenWidth * 0.15,
                  //     height: screenWidth * 0.15,
                  //   ),
                  // ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Join Buddy Queue?',
                    style: GoogleFonts.ubuntu(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'We’ll match you with another quitter who is also looking for an accountability partner',
                    style: GoogleFonts.ubuntu(
                      fontSize: screenWidth * 0.04,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.ubuntu(
                              fontSize: screenWidth * 0.04,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const FindingBuddyScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.bubbleColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015),
                          ),
                          child: Text(
                            'Team Up',
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
            ),
          ),
        );
      },
    );
  }
}
