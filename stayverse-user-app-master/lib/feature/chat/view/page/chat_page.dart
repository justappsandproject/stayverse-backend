import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/extension/widget_extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';
import 'package:stayverse/shared/app_icons.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/skeleton.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stayverse/feature/messaging/view/component/chat_error_screen.dart';
import 'package:stayverse/feature/messaging/view/component/chat_preload.dart';

class ChatPage extends ConsumerStatefulWidget {
  static const route = '/ChatPage';

  final Channel channel;

  const ChatPage({super.key, required this.channel});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  void initState() {
    super.initState();
    // Initialize the channel
    widget.channel.watch();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: widget.channel,
      child: FutureBuilder<bool>(
        future: widget.channel.initialized,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ChatErrorScreen(
              error: snapshot.error.toString(),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return ChatPreLoad(
              channel: widget.channel,
            );
          }
          return _ChatPageContent(channel: widget.channel);
        },
      ),
    );
  }
}

class _ChatPageContent extends ConsumerWidget {
  final Channel channel;

  const _ChatPageContent({required this.channel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BrimSkeleton(
      backgroundColor: context.color.surface,
      appBar: _buildAppBar(context),
      bodyPadding: EdgeInsets.zero,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
           
            Expanded(
              child: StreamMessageListView(
                emptyBuilder: (_) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No messages yet'),
                    ],
                  ),
                ),
                errorBuilder: (_, error) => Center(
                  child: Text('Error loading messages: ${error.toString()}'),
                ),
                messageBuilder: (context, details, messages, defaultMessage) {
                  return _buildCustomMessageBubble(context, details.message);
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: const Color(0xFFF3F4F6),
          height: 1,
        ),
      ),
      toolbarHeight: 80,
      surfaceTintColor: context.color.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: StreamBuilder<List<Member>>(
        stream: channel.state?.membersStream,
        builder: (context, snapshot) {
          final otherMembers = snapshot.data
                  ?.where((member) =>
                      member.user?.id != channel.client.state.currentUser?.id)
                  .toList() ??
              [];

          final otherUser =
              otherMembers.isNotEmpty ? otherMembers.first.user : null;

          return Row(
            children: [
              StreamUserAvatar(
                user: otherUser ?? User(id: 'unknown'),
                constraints: const BoxConstraints.tightFor(
                  height: 40,
                  width: 40,
                ),
                borderRadius: BorderRadius.circular(20),
                placeholder: (context, user) => CircleAvatar(
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
                            border: Border.all(
                                width: 3, color: context.color.surface),
                          ),
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF12B76A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      otherUser?.name ?? 'James Smith',
                      style: $styles.text.bodySmall.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: context.color.inverseSurface,
                      ),
                    ),
                    StreamConnectionStatusBuilder(
                      statusBuilder: (context, status) {
                        if (status == ConnectionStatus.connected) {
                          if (otherUser?.online == true) {
                          } else {}
                        }

                        return Row(
                          children: [
                            Text(
                              'Bookings: Chef',
                              style: $styles.text.bodySmall.copyWith(
                                fontWeight: FontWeight.w400,
                                color: context.color.inverseSurface,
                              ),
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
                                color: context.color.inverseSurface,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        AppBtn.basic(
          onPressed: () {},
          semanticLabel: '',
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const AppIcon(
              AppIcons.hori_more,
            ),
          ),
        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return StreamMessageInput(
      sendButtonLocation: SendButtonLocation.inside,
      onMessageSent: (message) {
        // Handle message sent if needed
      },
      idleSendButton: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ColoredBox(
          color: $styles.colors.greyMedium,
          child: const AppIcon(
            AppIcons.send,
            size: 22,
          ).paddingAll(4),
        ),
      ).paddingAll(4),
      activeSendButton: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ColoredBox(
          color: context.themeColors.primaryAccent,
          child: const AppIcon(
            AppIcons.send,
            size: 22,
          ).paddingAll(4),
        ),
      ).paddingAll(4),
    );
  }

  Widget _buildCustomMessageBubble(BuildContext context, Message message) {
    final isCurrentUser =
        message.user?.id == channel.client.state.currentUser?.id;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            StreamUserAvatar(
              user: message.user!,
              constraints: const BoxConstraints.tightFor(height: 24, width: 24),
            ),
            const Gap(8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? context.themeColors.primaryAccent
                    : context.color.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.text?.isNotEmpty == true)
                    Text(
                      message.text!,
                      style: $styles.text.bodySmall.copyWith(
                        color: isCurrentUser
                            ? Colors.white
                            : context.color.onSurface,
                      ),
                    ),
                  if (message.attachments.isNotEmpty)
                    ...message.attachments.map((attachment) {
                      if (attachment.type == 'image') {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: StreamImageAttachment(
                            message: message,
                            image: attachment,
                          ),
                        );
                      }
                      return StreamFileAttachment(
                        message: message,
                        file: attachment,
                      );
                    }),
                  const Gap(4),
                  Text(
                    _formatMessageTime(message.createdAt),
                    style: $styles.text.bodySmall.copyWith(
                      fontSize: 10,
                      color: isCurrentUser
                          ? Colors.white70
                          : context.color.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) ...[
            const Gap(8),
            StreamUserAvatar(
              user: message.user!,
              constraints: const BoxConstraints.tightFor(height: 24, width: 24),
            ),
          ],
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
