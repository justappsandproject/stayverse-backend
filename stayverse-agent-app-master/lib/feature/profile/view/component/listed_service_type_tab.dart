import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';

class ListedServiceTypeTab extends StatelessWidget {
  final TabController controller;

  const ListedServiceTypeTab({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.sp),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TabBar(
        controller: controller,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: _getBorderRadius(controller.index),
          color: context.color.primary,
        ),
        labelColor: context.color.surface,
        unselectedLabelColor: AppColors.grey5F,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 3.sp),
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Center(child: Text('Pending'))),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Center(child: Text('Approved'))),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Center(child: Text('Cancelled'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BorderRadius _getBorderRadius(int index) {
  if (index == 0) {
    // First tab → round left only
    return BorderRadius.only(
      topLeft: Radius.circular(25.r),
      bottomLeft: Radius.circular(25.r),
    );
  } else if (index == 2) {
    // Last tab → round right only
    return BorderRadius.only(
      topRight: Radius.circular(25.r),
      bottomRight: Radius.circular(25.r),
    );
  } else {
    // Middle tab → all round
    return BorderRadius.circular(25.r);
  }
}
