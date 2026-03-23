import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/shared/empty_state.dart';

typedef ItemViewBuilder<T> = Widget Function(
    BuildContext context, Widget? child, List<T> items);

class ItemView<T> extends StatelessWidget {
  ///Items you want to display
  final List<T>? items;

  ///Whether its loading or not
  final bool isAdsLoading;

  ///Builder call back
  final ItemViewBuilder<T> itemViewBuilder;

  ///Optional Child widget
  final Widget? child;

  ///Loading indicator default is set to liner progress bar
  final Widget? loader;

  final Widget? emptyState;

  const ItemView(
      {super.key,
      required this.items,
      required this.isAdsLoading,
      this.emptyState,
      required this.itemViewBuilder,
      this.loader,
      this.child});

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return emptyState ??
          const SizedBox(
              height: 200, width: double.infinity, child: EmptyState());
    }

    if (items!.isEmpty) {
      if (isAdsLoading) return loader ?? const LinearProgressIndicator();

      return emptyState ??
          const SizedBox(
              height: 200, width: double.infinity, child: EmptyState());
    }

    return itemViewBuilder.call(context, child, items!.toList());
  }
}
