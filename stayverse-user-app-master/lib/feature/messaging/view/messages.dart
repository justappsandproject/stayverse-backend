import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/service/streamChat/stream_client_service.dart';
import 'package:stayverse/feature/messaging/view/component/message_list_item.dart';
import 'package:stayverse/shared/skeleton.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({super.key});

  @override
  ConsumerState<MessagesPage> createState() => _MessagesState();
}

class _MessagesState extends ConsumerState<MessagesPage> {
  late StreamChannelListController _listController;

  @override
  void initState() {
    _loadChat();
    super.initState();
  }

  void _loadChat() {
    final id = StreamChat.of(context).currentUser?.id;
    _listController = StreamChannelListController(
      client: StreamClientService.instance.clientStream!,
      filter: Filter.and([
        Filter.equal('type', 'messaging'),
        Filter.in_(
          'members',
          [
            id ?? '',
          ],
        ),
      ]),
      channelStateSort: const [
        SortOption('last_message_at')
      ], // Sort by latest message
      limit: 20,
    );
    _listController.doInitialLoad();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
        isBusy: false,
        backgroundColor: Colors.white, // Match InboxPage background
        bodyPadding:
            const EdgeInsets.symmetric(horizontal: 16), // Adjust padding
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const SizedBox.shrink(),
          centerTitle: true,
          title: const Text(
            'Message',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Expanded(
                child: StreamChannelListView(
              itemBuilder: _channelTileBuilder,
              controller: _listController,
              loadingBuilder: (context) => const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.amber), // Match your theme
                  semanticsLabel: 'Loading',
                ),
              ),
              errorBuilder: (context, error) => SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const Gap(16),
                    Text(
                      'Unable to load messages',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Check your connection and try again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(24),
                    ElevatedButton(
                      onPressed: () {
                        _listController.doInitialLoad();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              emptyBuilder: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const Gap(16),
                    Text(
                      'No messages yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Start a conversation with someone',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              onChannelTap: (channel) {
                // This is handled in MessageListItem now
              },
            )),
          ],
        ));
  }
}

Widget _channelTileBuilder(BuildContext context, List<Channel> channels,
    int index, StreamChannelListTile defaultChannelTile) {
  final channel = channels[index];

  return MessageListItem(channel: channel);
}
