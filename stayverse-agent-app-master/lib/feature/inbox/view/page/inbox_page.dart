import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/util/image/app_assets.dart';
import 'package:stayvers_agent/feature/chat/view/page/chat_page.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        children: [
          Expanded(
            child: ListView(
              children: [
                MessageItem(
                  imageUrl: AppAsset.profilePic,
                  name: 'James Smith',
                  message: 'Pls take a look at the images.',
                  time: '18:31',
                  unreadCount: 3,
                  isHighlighted: true,
                ),
                const Gap(10),
                MessageItem(
                  imageUrl: AppAsset.profilePic,
                  name: 'Fullsnack Designer',
                  message: 'Hello guys, we have discussed about ...',
                  time: '16:04',
                ),
                const Gap(10),
                MessageItem(
                  imageUrl: AppAsset.profilePic,
                  name: 'Lee Williamson',
                  message: 'Yes, that’s gonna work, hopefully.',
                  time: '06:12',
                ),
                const Gap(10),
                MessageItem(
                  imageUrl: AppAsset.profilePic,
                  name: 'Ronald Mccoy',
                  message: 'Thanks dude 😉',
                  time: 'Yesterday',
                  hasReadIndicator: true,
                ),
                const Gap(10),
                MessageItem(
                  imageUrl: AppAsset.profilePic,
                  name: 'Albert Bell',
                  message: 'I‘m happy this anime has such grea...',
                  time: 'Yesterday',
                  hasReadIndicator: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String message;
  final String time;
  final int? unreadCount;
  final bool isHighlighted;
  final bool hasReadIndicator;
  final VoidCallback? onTap;

  const MessageItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.message,
    required this.time,
    this.unreadCount,
    this.isHighlighted = false,
    this.hasReadIndicator = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        $navigate.to(ChatPage.route);
      },
      splashColor: Colors.amber.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imageUrl),
              radius: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                if (unreadCount != null && unreadCount! > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (hasReadIndicator)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
