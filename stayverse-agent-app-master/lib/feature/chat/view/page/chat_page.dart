import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

import '../../controller/chat_rider_notifier.dart';
import '../component/chat_input_field.dart';
import '../component/chat_message_bubble.dart';

class ChatPage extends ConsumerWidget {
  static const route = '/ChatPage';
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BrimSkeleton(
      backgroundColor: context.color.surface,
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: const Color(0xFFF3F4F6),
              height: 1,
            )),
        toolbarHeight: 80,
        surfaceTintColor: context.color.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(AppAsset.profilePic),
              child: Stack(
                children: [
                  Positioned(
                    right: -3,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(width: 3, color: context.color.surface),
                      ),
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFF12B76A)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'James Smith',
                  style: $styles.text.bodySmall.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: context.color.inverseSurface),
                ),
                Row(
                  children: [
                    Text(
                      'Bookings: Chef',
                      style: $styles.text.bodySmall.copyWith(
                          fontWeight: FontWeight.w400,
                          color: context.color.inverseSurface),
                    ),
                    Gap(8.w),
                    Icon(
                      Icons.star,
                      color: context.color.secondary,
                      size: 12,
                    ),
                    Gap(4.w),
                    Text(
                      '4.4',
                      style: $styles.text.bodySmall.copyWith(
                          fontWeight: FontWeight.w400,
                          color: context.color.inverseSurface),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          AppBtn.basic(
            onPressed: () {},
            semanticLabel: '',
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.more_vert,
                color: context.color.inverseSurface,
              ),
            ),
          ),
          const Gap(20),
        ],
      ),
      bodyPadding: EdgeInsets.zero,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const Positioned.fill(
              child: Column(
                children: [
                  Expanded(
                    child: ChatMessageList(),
                  ),
                  Gap(60),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 0,
              right: 0,
              child: const ChatInputField(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageList extends ConsumerWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming you have a messages provider that returns List<ChatMessage>
    final messages = ref.watch(chatMessagesProvider);

    if (messages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('No messages yet')],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Column(
          children: [
            if (index == 0) // Display date only for the first message
              Center(
                child: Text(
                  '15 May 2020, 9:00 am',
                  style: $styles.text.bodySmall.copyWith(
                      fontWeight: FontWeight.w400,
                      color: context.color.inverseSurface),
                ),
              ),
            const Gap(16),
            ChatMessageBubble(message: message),
          ],
        );
      },
    );
  }
}
