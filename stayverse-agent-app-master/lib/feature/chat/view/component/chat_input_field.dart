import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/feature/chat/controller/chat_rider_notifier.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

class ChatInputField extends ConsumerStatefulWidget {
  const ChatInputField({super.key});

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _showSendButton = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey.shade50,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: 3,
                minLines: 1,
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _showSendButton = value.isNotEmpty;
                  });
                },
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Write a message...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined,
                        color: Colors.grey),
                    onPressed: () {},
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (_showSendButton)
              GestureDetector(
                onTap: () {
                  if (_controller.text.isNotEmpty) {
                    ref
                        .read(chatMessagesProvider.notifier)
                        .sendMessage(_controller.text);
                    _controller.clear();
                    setState(() {
                      _showSendButton = false;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: context.color.primary,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const AppIcon(
                    AppIcons.send_message,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
