import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

import '../../controller/dashboard_controller.dart';
import 'navigation_items.dart';

class CustomBottomBar extends ConsumerWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex =
        ref.watch(dashboadController.select((state) => state.currentPageIndex));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            offset: const Offset(0, -1),
            blurRadius: 10,
          ),
        ],
      ),
      height: 95.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            NavigationItems.items(ref).length,
            (index) => NavigationBarItem(
              item: NavigationItems.items(ref)[index],
              index: index,
              isActive: index == currentIndex,
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationBarItem extends ConsumerWidget {
  final NavigationItem item;
  final int index;
  final bool isActive;

  const NavigationBarItem({
    super.key,
    required this.item,
    required this.index,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconColor = index == 2
        ? null
        : isActive
            ? item.activeColor
            : const Color(0xFFD1D1D6);

    final serviceType = ref.watch(
        dashboadController.select((state) => state.user?.agent?.serviceType));

    // Only allow tap if it's NOT the middle button when serviceType is chef
    final bool isTapEnabled = !(index == 2 && serviceType == ServiceType.chef);

    return SizedBox(
      width: 63.w,
      child: Column(
        children: [
          AppIcon(
            item.icon,
            size: index != 2 ? 26 : 40,
            color: iconColor,
          )
              .animate(target: isActive ? 1 : 0)
              .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2))
              .then()
              .shake(),
          if (index != 2) ...[
            const Gap(8),
            Text(
              item.label,
              style: $styles.text.bodyBold.copyWith(
                fontSize: 12,
                color: isActive ? item.activeColor : const Color(0xFFD1D1D6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ).tap(
        onTap: isTapEnabled
            ? () => ref
                .read(dashboadController.notifier)
                .setCurrentPageIndex(index: index)
            : null, // Disable tap if not enabled
      ),
    );
  }
}
