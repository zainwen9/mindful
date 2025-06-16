import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/localDataProvider.dart';
import '../../provider/storiesProvider.dart';
import '../../resources/app_colors.dart';
import '../../services/firebase_basic.dart';
import '../../widgets/animatedNavigator.dart';
import '../../widgets/appSnackBar.dart';
import '../../widgets/customAlertDialogue.dart';
import '../buddy/TabButton.dart';
import 'StoryCard.dart';

class RecoveryStoriesScreen extends StatefulWidget {
  @override
  _RecoveryStoriesScreenState createState() => _RecoveryStoriesScreenState();
}

class _RecoveryStoriesScreenState extends State<RecoveryStoriesScreen> {
  int _selectedTabIndex = 0;
  bool _isAnonymous = false;
  int _selectedIndex = 1;
  int? _expandedStoryIndex;
  List<String> _hiddenStoryIds = [];

  void _showAddStoryBottomSheet(BuildContext context) {
    final TextEditingController _storyController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final data =
            Provider.of<LocalDataProvider>(context, listen: true).localData;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create a community post",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _storyController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: "Your story ....",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _isAnonymous,
                          onChanged: (value) {
                            setModalState(() {
                              setState(() {
                                _isAnonymous = value ?? false;
                              });
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: ColorManager.bubbleColor,
                        ),
                        const Text(
                          "Share anonymously",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                _isAnonymous = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade800,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_storyController.text.isNotEmpty) {
                                AppNavigator.off();
                                QuickAlert.show(
                                    type: QuickAlertType.loading,
                                    headerBackgroundColor: Colors.white,
                                    confirmBtnColor: Colors.black,
                                    buttonFunction: () {
                                      //  AppNavigator.to(const TermOfUseScreen());
                                    },
                                    title: "Posting...");
                                await FirebaseGeneralServices()
                                    .saveData(collectionPath: "Stories", data: {
                                  'content': _storyController.text,
                                  'anonymously': _isAnonymous,
                                  'time': DateTime.now(),
                                  'likes': 0,
                                  'dislikes': 0,
                                  'sender': {
                                    'name': _isAnonymous
                                        ? "Anonymous"
                                        : data!['name'],
                                    'image': _isAnonymous ? "" : data!['image'],
                                    'id': data!['uid']
                                  }
                                });

                                AppNavigator.off();
                              } else {
                                snaki(msg: "Write Some Thing");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.bubbleColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              "Share Story",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Note: Share what feels right for you. Your privacy matters – you can remain anonymous.",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
              child: Text(
                "Recovery Stories",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 0;
                      });
                    },
                    child: TabButton(
                      title: 'Trending',
                      isSelected: _selectedTabIndex == 0,
                      context: context,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 1;
                      });
                    },
                    child: TabButton(
                      title: 'New',
                      isSelected: _selectedTabIndex == 1,
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: [
                  Consumer<StoriesProvider>(
                    builder: (context, storiesProvider, child) {
                      return StreamBuilder<List<Map<String, dynamic>>>(
                        stream: storiesProvider.getStoriesStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text(
                                  "No stories available",
                                  style: TextStyle(color: Colors.white),
                                ));
                          }

                          final stories = snapshot.data!
                              .asMap()
                              .entries
                              .where((entry) =>
                          !_hiddenStoryIds.contains(entry.value['id']))
                              .map((entry) => MapEntry(entry.key, entry.value))
                              .toList();

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: stories.length,
                            itemBuilder: (context, index) {
                              final storyIndex = stories[index].key;
                              final story = stories[index].value;
                              return StoryCard(
                                sender: story["sender"],
                                storySnippet: story["content"],
                                upvoteCount: story["likes"],
                                downvoteCount: story["dislikes"],
                                isExpanded: _expandedStoryIndex == storyIndex,
                                onToggleExpand: () {
                                  setState(() {
                                    _expandedStoryIndex =
                                    _expandedStoryIndex == storyIndex
                                        ? null
                                        : storyIndex;
                                  });
                                },
                                onHide: () {
                                  setState(() {
                                    _hiddenStoryIds.add(story['id']);
                                  });
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const Center(
                    child: Text(
                      "New Stories Coming Soon",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddStoryBottomSheet(context);
        },
        backgroundColor: ColorManager.bubbleColor,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
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
}