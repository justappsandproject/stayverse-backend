import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/shared/empty_state_view.dart';

class EmptyState extends StatelessWidget {
  final String? message;
  final EmptyStateType _emptyStateType;

  ///By default [EmptyState] is set to[EmptyStateType.normal]
  const EmptyState({
    super.key,
    this.message,
  }) : _emptyStateType = EmptyStateType.normal;

  ///[EmptyState.silver] allows you show an empty state on a sliver list or sliver widget
  const EmptyState.sliver({
    super.key,
    this.message,
  }) : _emptyStateType = EmptyStateType.sliver;

  ///[EmptyState.normal] allows you show an empty state on a nomal listview,column and so on
  const EmptyState.normal({
    super.key,
    this.message,
  }) : _emptyStateType = EmptyStateType.normal;

  @override
  Widget build(BuildContext context) => switch (_emptyStateType) {
        EmptyStateType.normal => Expanded(
            child: EmptyStateView(
              message: message,
            ),
          ),
        EmptyStateType.sliver => SliverFillRemaining(
            child: EmptyStateView(
              message: message,
            ),
          ),
      };
}

enum EmptyStateType { sliver, normal }
