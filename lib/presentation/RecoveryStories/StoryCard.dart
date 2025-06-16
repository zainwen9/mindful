import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../resources/app_colors.dart';

class StoryCard extends StatelessWidget {
  final Map<String, dynamic>? sender;
  final String? storySnippet;
  final int upvoteCount;
  final int downvoteCount;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onHide;

  const StoryCard({
    super.key,
    this.sender,
    this.storySnippet,
    required this.upvoteCount,
    required this.downvoteCount,
    this.isExpanded = false,
    required this.onToggleExpand,
    required this.onHide,
  });

  // Determine if the story text fits within 3 lines
  bool _isStoryShort(BuildContext context) {
    final text = storySnippet ?? 'No story available';
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.roboto(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14,
          height: 1.5,
        ),
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );

    // Estimate the width of the text area (accounting for padding and avatar)
    final width = MediaQuery.of(context).size.width - 32 - 32 - 12 - 24; // screen width - margins - avatar - spacing
    textPainter.layout(maxWidth: width);

    return !textPainter.didExceedMaxLines;
  }

// Show the report confirmation dialog
  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Thank you",
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Ensure the column takes only the space it needs
            children: [
              Text(
                "for looking out for yourself and your fellow Quitters we will review and take further action if necessary",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16), // Add some spacing between the text and the divider
              const Divider(
                color: Colors.grey, // Color of the divider
                thickness: 1, // Thickness of the divider
                height: 1, // Height of the divider (affects spacing)
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                child: Text(
                  "OK",
                  style: GoogleFonts.roboto(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double baseHeight = 200.0;
    final senderName = sender?['name']?.toString() ?? 'Anonymous';
    final senderImage = sender?['image']?.toString() ?? '';
    final isShortStory = _isStoryShort(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isExpanded ? null : baseHeight, // Dynamic height when expanded
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Main content
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        senderImage.isEmpty
                            ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 16,
                          child: Text(
                            senderName.isNotEmpty ? senderName.substring(0, 1) : 'A',
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                            : CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(senderImage),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          senderName,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        // PopupMenuButton with Hide and Report options
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                            size: 24,
                          ),
                          onSelected: (String value) {
                            if (value == 'Hide') {
                              onHide(); // Call the hide callback
                            } else if (value == 'Report') {
                              _showReportDialog(context); // Show the report dialog
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'Hide',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.visibility_off,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Hide',
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Report',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.flag,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Report',
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          color: Colors.white, // Background color of the popup
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 8, // Shadow elevation
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      storySnippet ?? 'No story available',
                      style: GoogleFonts.roboto(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                    // Extra padding to avoid overlap with bottom row
                    const SizedBox(height: 48),
                  ],
                ),
              ),
              // Bottom row (pinned to bottom)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  children: [
                    // Conditional "Read" or "Collapse" text
                    if (!isShortStory && !isExpanded)
                      GestureDetector(
                        onTap: onToggleExpand,
                        child: Text(
                          "Read $senderName story",
                          style: GoogleFonts.roboto(
                            color: ColorManager.bubbleColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    if (isExpanded)
                      GestureDetector(
                        onTap: onToggleExpand,
                        child: Text(
                          "Collapse",
                          style: GoogleFonts.roboto(
                            color: ColorManager.bubbleColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const Spacer(),
                    // Upvote/downvote icons (always visible)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E3738),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.keyboard_arrow_up,
                                  color: Color(0xFF00C4B4),
                                  size: 24,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  upvoteCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 36,
                            color: Colors.black,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Text(
                                  downvoteCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}