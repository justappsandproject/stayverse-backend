import 'package:dio/dio.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/feature/inbox/model/data/curated_message.dart';
import 'package:stayverse/shared/skeleton.dart';

class InboxPage extends StatefulWidget {
  static const route = '/CuratedMessagesPage';
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  bool _isLoading = true;
  List<CuratedMessage> _messages = const [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadMessages);
  }

  Future<void> _loadMessages() async {
    try {
      final response = await locator.get<Dio>().get<Map<String, dynamic>>(
            '/notification/curated',
            queryParameters: const {'page': 1, 'limit': 20},
          );
      final serverResponse = ServerResponse.fromJson(response.data ?? {});
      final payload = serverResponse.data;
      final items = payload is Map<String, dynamic>
          ? (payload['data'] as List<dynamic>? ?? const [])
          : const <dynamic>[];

      if (!mounted) return;
      setState(() {
        _messages = items
            .whereType<Map<String, dynamic>>()
            .map(CuratedMessage.fromJson)
            .toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages = const [];
        _isLoading = false;
      });
    }
  }

  Future<void> _markRead(CuratedMessage message) async {
    try {
      final response = await locator.get<Dio>().post<Map<String, dynamic>>(
            '/notification/curated/${message.id}/read',
          );
      final serverResponse = ServerResponse.fromJson(response.data ?? {});
      final payload = serverResponse.data;
      if (payload is! Map<String, dynamic>) return;
      final updated = CuratedMessage.fromJson(payload);
      if (!mounted) return;
      setState(() {
        _messages = _messages
            .map((item) => item.id == updated.id ? updated : item)
            .toList();
      });
    } catch (_) {}
  }

  Future<void> _reactToMessage(
    CuratedMessage message,
    String reaction,
  ) async {
    try {
      final response = await locator.get<Dio>().post<Map<String, dynamic>>(
            '/notification/curated/${message.id}/react',
            data: {'reaction': reaction},
          );
      final serverResponse = ServerResponse.fromJson(response.data ?? {});
      final payload = serverResponse.data;
      if (payload is! Map<String, dynamic>) return;
      final updated = CuratedMessage.fromJson(payload);
      if (!mounted) return;
      setState(() {
        _messages = _messages
            .map((item) => item.id == updated.id ? updated : item)
            .toList();
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        centerTitle: true,
        title: const Text(
          'Curated Messages',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMessages,
              child: _messages.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 140),
                        Center(
                          child: Text(
                            'No curated messages yet.',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      separatorBuilder: (_, __) => const Gap(12),
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _CuratedMessageCard(
                          message: message,
                          onOpen: () => _markRead(message),
                          onReact: (reaction) => _reactToMessage(message, reaction),
                        );
                      },
                    ),
            ),
    );
  }
}

class _CuratedMessageCard extends StatelessWidget {
  final CuratedMessage message;
  final VoidCallback onOpen;
  final ValueChanged<String> onReact;

  const _CuratedMessageCard({
    required this.message,
    required this.onOpen,
    required this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Gap(8),
            if (message.imageUrl != null && message.imagePosition == 'before')
              _MessageImage(url: message.imageUrl!),
            Text(
              message.body,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.grey.shade700,
              ),
            ),
            if (message.imageUrl != null && message.imagePosition != 'before')
              _MessageImage(url: message.imageUrl!),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDate(message.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                Text(
                  message.read ? 'Read' : 'Unread',
                  style: TextStyle(
                    fontSize: 12,
                    color: message.read ? Colors.green.shade700 : Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                _ReactionButton(
                  label: 'Helpful',
                  selected: message.reaction == 'like',
                  onTap: () => onReact('like'),
                ),
                const Gap(8),
                _ReactionButton(
                  label: 'Not useful',
                  selected: message.reaction == 'dislike',
                  onTap: () => onReact('dislike'),
                ),
                const Spacer(),
                Text(
                  'V:${message.viewedCount} R:${message.readCount}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) return 'Recently';
    final local = value.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/${local.year} $hour:$minute';
  }
}

class _MessageImage extends StatelessWidget {
  final String url;

  const _MessageImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ReactionButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.black87 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
