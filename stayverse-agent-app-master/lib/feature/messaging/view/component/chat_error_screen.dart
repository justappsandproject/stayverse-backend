
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class ChatErrorScreen extends StatelessWidget {
  const ChatErrorScreen({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      backgroundColor: context.color.surface,
      isBusy: false,
      appBar: _buildErrorAppBar(context),
      bodyPadding: EdgeInsets.zero,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: _buildErrorMessageArea(context),
            ),
            _buildDisabledMessageInput(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildErrorAppBar(BuildContext context) {
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
          CircleAvatar(
            radius: 20,
            backgroundColor: context.color.error.withOpacity(0.1),
            child: Icon(
              Icons.error_outline,
              color: context.color.error,
              size: 20,
            ),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat Error',
                  style: $styles.text.bodySmall.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: context.color.inverseSurface,
                  ),
                ),
                const Gap(2),
                Row(
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: context.color.error,
                      size: 12,
                    ),
                    Gap(4.w),
                    Text(
                      'Connection failed',
                      style: $styles.text.bodySmall.copyWith(
                        fontWeight: FontWeight.w400,
                        color: context.color.error,
                        fontSize: 12,
                      ),
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
              color: context.color.onSurface.withOpacity(0.3),
            ),
          ),
        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildErrorMessageArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          // Error message in chat bubble style
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: context.color.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: context.color.error.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getProductionErrorMessage(error),
                          textAlign: TextAlign.center,
                          style: $styles.text.bodySmall.copyWith(
                            color: context.color.onErrorContainer,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        const Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'System',
                              style: $styles.text.bodySmall.copyWith(
                                fontSize: 10,
                                color: context.color.onErrorContainer
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Go back button
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Go Back',
                          style: $styles.text.bodySmall.copyWith(
                            fontSize: 16,
                            color: AppColors.black,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: context.color.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: context.color.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chat unavailable...',
                      style: $styles.text.bodySmall.copyWith(
                        color: context.color.onSurface.withOpacity(0.4),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: $styles.colors.greyMedium.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: AppIcon(
                      AppIcons.send,
                      size: 18,
                      color: $styles.colors.lightGrey.withOpacity(0.5),
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

  String _getProductionErrorMessage(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout')) {
      return 'Unable to connect to chat.\nPlease check your internet connection and try again.';
    }

    if (lowerError.contains('unauthorized') ||
        lowerError.contains('403') ||
        lowerError.contains('permission')) {
      return 'You don\'t have permission to access this chat.\nPlease contact support if this seems wrong.';
    }

    if (lowerError.contains('not found') || lowerError.contains('404')) {
      return 'This chat is no longer available.\nThe seller may have removed their listing.';
    }

    if (lowerError.contains('rate limit') ||
        lowerError.contains('429') ||
        lowerError.contains('too many')) {
      return 'Too many requests.\nPlease wait a moment and try again.';
    }

    if (lowerError.contains('server') ||
        lowerError.contains('500') ||
        lowerError.contains('internal')) {
      return 'Our servers are experiencing issues.\nPlease try again in a few minutes.';
    }

    if (lowerError.contains('maintenance') ||
        lowerError.contains('unavailable')) {
      return 'Chat is temporarily unavailable for maintenance.\nPlease try again later.';
    }

    return 'Chat is currently unavailable.\nYou can try again later or contact the seller directly.';
  }
}
