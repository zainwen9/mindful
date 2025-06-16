import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_health/presentation/buddy/supportHub.dart';

class ChatScreen extends StatefulWidget {
  final String? initialMessage;

  const ChatScreen({super.key, this.initialMessage});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {"text": "Hey Samuel.", "isMe": false},
    {"text": "I know the struggle, but keep on brother we got this!", "isMe": false},
  ];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _messages.add({"text": widget.initialMessage!, "isMe": true});
        });
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({"text": _messageController.text, "isMe": true});
    });
    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.015),
          Center(
            child: Text(
              "Today",
              style: GoogleFonts.ubuntu(
                fontSize: screenWidth * 0.035,
                color: Colors.white60,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index]["text"];
                final isMe = _messages[index]["isMe"];
                if (message.startsWith("Daily Check-In")) {
                  return _buildDailyCheckInMessage(message, screenWidth);
                } else {
                  return _buildChatBubble(message, isMe, screenWidth);
                }
              },
            ),
          ),
          _buildMessageInput(screenWidth, screenHeight),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SupportHubScreen()),
          );
        },
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: const AssetImage('assets/josh.png'),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.025),
          Text(
            "Josh",
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildChatBubble(String message, bool isMe, double screenWidth) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
        padding: EdgeInsets.all(screenWidth * 0.035),
        constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF26A97A) : Colors.grey[900],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: isMe ? const Radius.circular(18) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(18),
          ),
        ),
        child: Text(
          message,
          style: GoogleFonts.ubuntu(
            fontSize: screenWidth * 0.04,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDailyCheckInMessage(String message, double screenWidth) {
    final parts = message.split(" ");
    if (parts.length < 5) {
      return _buildChatBubble(message, true, screenWidth);
    }

    final emoji = parts[2];
    final feeling = parts[3].replaceAll("!", "");
    final status = parts[4];
    final trigger = parts.sublist(5).join(" ");

    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
        padding: EdgeInsets.all(screenWidth * 0.05),
        constraints: BoxConstraints(maxWidth: screenWidth * 0.85),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(screenWidth * 0.06),
          border: Border.all(width: 1, color: Colors.white.withOpacity(0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: screenWidth * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF03C390).withOpacity(0.24),
              ),
              child: Center(
                child: Text(
                  "Daily Check-In",
                  style: GoogleFonts.ubuntu(
                    fontSize: screenWidth * 0.04,
                    color: const Color(0xFF03C390),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
            _buildDailyCheckInRow("FEELING", "$emoji $feeling!", screenWidth),
            SizedBox(height: screenWidth * 0.01),
            Divider(thickness: 1, color: Colors.white.withOpacity(0.12)),
            SizedBox(height: screenWidth * 0.01),
            _buildDailyCheckInRow("STATUS", status, screenWidth),
            SizedBox(height: screenWidth * 0.01),
            Divider(thickness: 1, color: Colors.white.withOpacity(0.12)),
            SizedBox(height: screenWidth * 0.01),
            _buildDailyCheckInRow("TRIGGER", trigger, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCheckInRow(String label, String value, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.ubuntu(
            fontSize: screenWidth * 0.04,
            color: Colors.grey,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.ubuntu(
              fontSize: screenWidth * 0.04,
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.025),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white60),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type Here...",
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.white60),
            onPressed: () {},
          ),
          FloatingActionButton(
            onPressed: _sendMessage,
            backgroundColor: const Color(0xFF26A97A),
            mini: true,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}