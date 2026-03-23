
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatPreLoad extends StatefulWidget {
  const ChatPreLoad({super.key, required this.channel});
  final Channel channel;

  @override
  State<ChatPreLoad> createState() => _ChatPreLoadState();
}

class _ChatPreLoadState extends State<ChatPreLoad>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    _shimmerController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: context.color.surface,
      isBusy: false,
      appBar: _buildSkeletonAppBar(context),
      bodyPadding: EdgeInsets.zero,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: _buildSkeletonMessageList(context),
            ),
            _buildSkeletonMessageInput(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildSkeletonAppBar(BuildContext context) {
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
      title: Row(
        children: [
          // Skeleton avatar with shimmer effect
          _buildSkeletonAvatar(),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skeleton name
                _buildShimmerContainer(
                  width: 120,
                  height: 16,
                  borderRadius: 4,
                ),
                const Gap(4),
                // Skeleton status row
                Row(
                  children: [
                    _buildShimmerContainer(
                      width: 80,
                      height: 12,
                      borderRadius: 4,
                    ),
                    Gap(8.w),
                    Icon(
                      Icons.star,
                      color: Colors.grey[400],
                      size: 12,
                    ),
                    Gap(4.w),
                    _buildShimmerContainer(
                      width: 20,
                      height: 12,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ],
            ),
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
            child: AppIcon(
              AppIcons.hori_more,
              color: Colors.grey[500],
            ),
          ),
        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildSkeletonMessageList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      children: [
        // Date skeleton
        Center(
          child: _buildShimmerContainer(
            width: 150,
            height: 14,
            borderRadius: 4,
          ),
        ),
        const Gap(16),
        // Received message skeleton
        _buildSkeletonMessage(context, isCurrentUser: false),
        const Gap(8),
        // Sent message skeleton
        _buildSkeletonMessage(context, isCurrentUser: true),
        const Gap(8),
        // Another received message skeleton
        _buildSkeletonMessage(context, isCurrentUser: false),
        const Gap(8),
        // Sent message skeleton
        _buildSkeletonMessage(context, isCurrentUser: true),
        const Gap(8),
        // Long received message skeleton
        _buildSkeletonMessage(context,
            isCurrentUser: false, isLongMessage: true),
      ],
    );
  }

  Widget _buildSkeletonMessage(BuildContext context,
      {required bool isCurrentUser, bool isLongMessage = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            _buildSkeletonAvatar(radius: 12),
            const Gap(8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.blue[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message text skeleton
                  _buildShimmerContainer(
                    width: isLongMessage
                        ? double.infinity
                        : (isCurrentUser ? 150 : 120),
                    height: 14,
                    borderRadius: 4,
                  ),
                  if (isLongMessage) ...[
                    const Gap(4),
                    _buildShimmerContainer(
                      width: 200,
                      height: 14,
                      borderRadius: 4,
                    ),
                  ],
                  const Gap(8),
                  // Time skeleton
                  _buildShimmerContainer(
                    width: 30,
                    height: 10,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) ...[
            const Gap(8),
            _buildSkeletonAvatar(radius: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildSkeletonMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildShimmerContainer(
                      width: double.infinity,
                      height: 16,
                      borderRadius: 4,
                    ),
                  ),
                  const Gap(8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AppIcon(
                      AppIcons.send,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonAvatar({double radius = 20}) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.lerp(
          Colors.grey[200],
          Colors.grey[300],
          _shimmerAnimation.value,
        ),
      ),
      child: radius == 20
          ? Stack(
              children: [
                Positioned(
                  right: -3,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 3, color: Colors.white),
                    ),
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.lerp(
                          Colors.green[300],
                          Colors.green[500],
                          _shimmerAnimation.value,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildShimmerContainer({
    required double width,
    required double height,
    double borderRadius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Color.lerp(
          Colors.grey[200],
          Colors.grey[400],
          _shimmerAnimation.value,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
