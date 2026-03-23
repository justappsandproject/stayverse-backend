import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  static const route = '/LoginPage';
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  AssetImage('assets/profile.jpg'), // Replace with actual image
            ),
            SizedBox(width: 10),
            Text("Mike Mazowski"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: const ChatBody(),
    );
  }
}

class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _messageBubble(
                sender: "Mike Mazowski",
                text:
                    "Hello guys, we have discussed about post-corona vacation plan and our decision is to go to Bali. We will have a very big party after this corona ends! These are some images about our destination",
                time: "16:04",
                isMe: false,
              ),
              _imageGrid(),
              _messageBubble(
                sender: "You",
                text:
                    "That's a very nice place! You guys made a very good decision. Can't wait to go on vacation!",
                time: "16:04",
                isMe: true,
              ),
            ],
          ),
        ),
        _messageInputField(),
      ],
    );
  }

  Widget _messageBubble(
      {required String sender,
      required String text,
      required String time,
      required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(sender,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isMe ? Colors.amber : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _imageGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          Image.asset("assets/image1.jpg",
              width: 180, height: 120, fit: BoxFit.cover),
          Image.asset("assets/image2.jpg",
              width: 90, height: 90, fit: BoxFit.cover),
          Image.asset("assets/image3.jpg",
              width: 90, height: 90, fit: BoxFit.cover),
        ],
      ),
    );
  }

  Widget _messageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: const Row(
        children: [
          Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Write a message...",
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.attach_file, color: Colors.grey),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
