import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/extension/extension.dart';

import '../../model/chat_message_model.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: isMe ? 64 : 16,
                right: isMe ? 16 : 64,
                top: 4,
                bottom: 4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isMe ? context.color.primary : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 16),
                ),
              ),
              child: Text(
                message.content,
                style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: isMe ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
            Padding(
              padding: isMe
                  ? const EdgeInsets.only(right: 16)
                  : const EdgeInsets.only(left: 16),
              child: Text(
                DateFormat.jm().format(message.timestamp),
                style: $styles.text.bodySmall.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
