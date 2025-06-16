import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/storiesProvider.dart';


class RecoveryStories extends StatelessWidget {
  const RecoveryStories({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions and calculate scale factor
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: (screenHeight * 0.22).clamp(120.0, 180.0), // Clamped height
      child: Consumer<StoriesProvider>(
        builder: (context, storiesProvider, child) {
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: storiesProvider.getStoriesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text(
                      "No stories available",
                      style: TextStyle(color: Colors.white),
                    ));
              }

              final stories = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: stories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        right: (screenWidth * 0.04)
                            .clamp(10.0, 20.0)), // Responsive spacing
                    child: Container(
                      width: (screenWidth * 0.85).clamp(
                          280.0, 400.0), // Responsive width with clamping
                      decoration: BoxDecoration(
                        color: const Color(0xFF12161C),
                        borderRadius: BorderRadius.circular(
                            (screenWidth * 0.06).clamp(16.0, 24.0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            (screenWidth * 0.04).clamp(10.0, 16.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                stories[index]["sender"]['image'] == ""
                                    ? CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 16,
                                  child: Text(
                                    stories[index]["sender"]['name']
                                        .toString()
                                        .substring(0, 1),
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                    : CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                      stories[index]["sender"]['image']),
                                ),
                                SizedBox(
                                    width:
                                    (screenWidth * 0.02).clamp(5.0, 10.0)),

                                // Name
                                Text(
                                  stories[index]["sender"]['name']
                                      .toString()
                                      .trim()
                                      .split(' ')
                                      .first,
                                  style: TextStyle(
                                    fontSize:
                                    (screenWidth * 0.04).clamp(14.0, 16.0),
                                    color: const Color(0xFF999999),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const Spacer(),

                                // Voting container
                                Container(
                                  height:
                                  (screenHeight * 0.05).clamp(32.0, 40.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF333333),
                                    borderRadius: BorderRadius.circular(
                                        (screenWidth * 0.06).clamp(16.0, 24.0)),
                                  ),
                                  child: Row(
                                    children: [
                                      // Upvote
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: (screenWidth * 0.03)
                                                .clamp(8.0, 12.0)),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                              color: Color(0xFF222222),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_drop_up,
                                              color: const Color(0xFF4ECCA3),
                                              size: (screenWidth * 0.06)
                                                  .clamp(20.0, 24.0),
                                            ),
                                            SizedBox(
                                                width: (screenWidth * 0.01)
                                                    .clamp(3.0, 5.0)),
                                            Text(
                                              stories[index]["likes"]
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: (screenWidth * 0.045)
                                                    .clamp(14.0, 18.0),
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Downvote
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: (screenWidth * 0.03)
                                                .clamp(8.0, 12.0)),
                                        child: Row(
                                          children: [
                                            Text(
                                              stories[index]["dislikes"]
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: (screenWidth * 0.045)
                                                    .clamp(14.0, 18.0),
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                                width: (screenWidth * 0.01)
                                                    .clamp(3.0, 5.0)),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color: const Color(0xFFFF6B6B),
                                              size: (screenWidth * 0.06)
                                                  .clamp(20.0, 24.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                                height:
                                (screenHeight * 0.015).clamp(8.0, 12.0)),

                            // Post content
                            Text(
                              stories[index]["content"],
                              style: TextStyle(
                                fontSize:
                                (screenWidth * 0.02).clamp(12.0, 16.0),
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
