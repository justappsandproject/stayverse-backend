import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/color/color_utils.dart';
import 'package:stayvers_agent/feature/messaging/view/chats.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MessageListItem extends StatelessWidget {
  const MessageListItem({
    super.key,
    required this.channel,
  });

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        $navigate.toWithParameters(Chats.route, args: channel);
      },
      splashColor: Colors.amber.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            StreamChannelAvatar(
              borderRadius: BorderRadius.circular(24),
              channel: channel,
              constraints: const BoxConstraints(
                maxHeight: 48,
                maxWidth: 48,
                minHeight: 48,
                minWidth: 48,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Channel Name
                  StreamChannelName(
                    channel: channel,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Last Message Preview
                  StreamBuilder<Message?>(
                    stream: channel.state?.lastMessageStream,
                    initialData: channel.state?.lastMessage,
                    builder: (context, snapshot) {
                      final lastMessage = snapshot.data;
                      String messageText = 'No messages yet';

                      if (lastMessage != null) {
                        if (lastMessage.text?.isNotEmpty == true) {
                          messageText = lastMessage.text!;
                        } else if (lastMessage.attachments.isNotEmpty) {
                          final attachment = lastMessage.attachments.first;
                          switch (attachment.type) {
                            case 'image':
                              messageText = '📷 Photo';
                              break;
                            case 'file':
                              messageText = '📎 File';
                              break;
                            case 'video':
                              messageText = '🎥 Video';
                              break;
                            default:
                              messageText = '📎 Attachment';
                          }
                        }
                      }

                      return Text(
                        messageText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Last Message Time
                ChannelLastMessageDate(
                  channel: channel,
                  textStyle: $styles.text.bodySmall.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.grey.shade500),
                ),
                const SizedBox(height: 4),
                // Unread Count or Read Indicator
                StreamBuilder<int>(
                  stream: channel.state?.unreadCountStream,
                  initialData: channel.state?.unreadCount ?? 0,
                  builder: (context, snapshot) {
                    final unreadCount = snapshot.data ?? 0;

                    if (unreadCount > 0) {
                      return Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : '$unreadCount',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else {
                      // Show read indicator for sent messages
                      return StreamBuilder<Message?>(
                        stream: channel.state?.lastMessageStream,
                        initialData: channel.state?.lastMessage,
                        builder: (context, snapshot) {
                          final lastMessage = snapshot.data;
                          final currentUser =
                              StreamChat.of(context).currentUser;

                          // Only show read indicator if current user sent the last message
                          if (lastMessage?.user?.id == currentUser?.id) {
                            return const Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.grey,
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UnreadMessage extends StatelessWidget {
  final Channel channel;

  const UnreadMessage({super.key, required this.channel});

  @override
  Widget build(BuildContext context) => BetterStreamBuilder<int>(
        stream: channel.state?.unreadCountStream,
        initialData: 0,
        builder: (BuildContext context, int data) => switch (data) {
          (int data) when data > 0 => Container(
              padding: const EdgeInsets.only(
                left: 5,
                right: 5,
                top: 2,
                bottom: 2,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorUtils.parseHex('#FFCC91')),
              child: Text('${data > 99 ? '99+' : data}',
                  textAlign: TextAlign.center,
                  style: $styles.text.bodySmall.copyWith(
                      fontWeight: FontWeight.w400,
                      color: $styles.colors.offWhite,
                      fontSize: 14.sp)),
            ),
          _ => const SizedBox.shrink()
        },
      );
}
