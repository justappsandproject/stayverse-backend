import 'package:dio/dio.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/feature/inbox/model/data/curated_message.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

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

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                        return _CuratedMessageCard(message: message);
                      },
                    ),
            ),
    );
  }
}

class _CuratedMessageCard extends StatelessWidget {
  final CuratedMessage message;

  const _CuratedMessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            message.body,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.grey.shade700,
            ),
          ),
          const Gap(12),
          Text(
            _formatDate(message.createdAt),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
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
