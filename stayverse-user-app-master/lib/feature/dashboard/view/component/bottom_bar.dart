import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayverse/feature/dashboard/view/component/navigation_item.dart';
import 'package:stayverse/shared/app_icons.dart';

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
            color: Colors.black.withOpacity(0.07),
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
            NavigationItems.items.length,
            (index) => NavigationBarItem(
              item: NavigationItems.items[index],
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
    return SizedBox(
      width: 63.w,
      child: Column(
        children: [
          AppIcon(
            item.icon,
            size: 26,
            color: isActive ? item.activeColor : const Color(0xFFD1D1D6),
          )
              .animate(
                  target: isActive ? 1 : 0) // Animate based on active state
              .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2)) // Scale effect
              .then()
              .shake(), // Adds a subtle shake effect

          const Gap(8),

          Text(
            item.label,
            style: $styles.text.bodyBold.copyWith(
              fontSize: 12,
              color: isActive ? item.activeColor : const Color(0xFFD1D1D6),
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ).tap(
        onTap: () => ref
            .read(dashboadController.notifier)
            .setCurrentPageIndex(index: index),
      ),
    );
  }
}
