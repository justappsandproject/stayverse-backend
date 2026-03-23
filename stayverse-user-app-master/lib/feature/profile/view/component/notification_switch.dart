import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/feature/profile/controller/profile_controller.dart';
import 'package:stayverse/feature/dashBoard/controller/dashboard_controller.dart';

class NotificationSwitch extends ConsumerWidget {
  const NotificationSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUpdating = ref.watch(
        profileController.select((value) => value.isUpdatingNotification));
    final isEnabled = ref.watch(dashboadController
        .select((value) => value.user?.notificationsEnabled ?? false));

    return Transform.scale(
      scale: 0.9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Switch.adaptive(
            value: isEnabled,
            onChanged: isUpdating
                ? null
                : (value) {
                    ref
                        .read(profileController.notifier)
                        .updateNotificationPreference(value);
                  },
            thumbColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.white;
                }
                if (states.contains(WidgetState.selected)) {
                  return context.color.primary;
                }
                return Colors.white;
              },
            ),
            trackColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey.shade100;
                }
                if (states.contains(WidgetState.selected)) {
                  return context.color.primary.withValues(alpha: 0.3);
                }
                return Colors.grey.shade300;
              },
            ),
          ),
          if (isUpdating)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.color.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
