import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../resources/constant_functions.dart';
import '../../services/firebase_basic.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  _CommunityChatScreenState createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_controller.text.trim().isEmpty) return;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseGeneralServices().saveData(collectionPath: "GroupChat", data: {
      "text": _controller.text,
      "uId": uid,
      "time": getFormattedTime(),
      "date": DateTime.now(),
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.greenAccent),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Go back",
          style: TextStyle(color: Colors.greenAccent, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // StreamBuilder to listen to Firebase Firestore updates
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('GroupChat')
                  .orderBy('date') // Order messages by date or timestamp
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!.docs.map((doc) {
                  return {
                    "text": doc['text'],
                    "isMe":
                        doc['uId'] == FirebaseAuth.instance.currentUser!.uid,
                    "time":
                        getFormattedTime(), // Optionally, use the time from Firestore
                  };
                }).toList();

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: messages.length,
                  reverse: false,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ChatBubble(
                      message: message["text"],
                      isMe: message["isMe"],
                      time: message["time"],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.mic, color: Colors.grey),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type Here...",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {},
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            backgroundColor: Colors.greenAccent,
            mini: true,
            child: Icon(Icons.send, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isMe,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.white : Colors.grey[900],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: isMe ? Radius.circular(16) : Radius.zero,
                bottomRight: isMe ? Radius.zero : Radius.circular(16),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.black : Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: isMe ? 0 : 12, right: isMe ? 12 : 0),
            child: Text(
              time,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
