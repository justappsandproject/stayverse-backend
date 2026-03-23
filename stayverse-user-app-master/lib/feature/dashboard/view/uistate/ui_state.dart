import 'package:stayverse/core/data/current_user.dart';

class DashBoardUiState {
  final bool isBusy;

  final int currentPageIndex;
  final CurrentUser? user;

  DashBoardUiState({
    this.isBusy = false,
    this.user,
    this.currentPageIndex = 0,
  });

  DashBoardUiState copyWith({
    bool? isBusy,
    String? error,
    CurrentUser? user,
    int? currentPageIndex,
  }) {
    return DashBoardUiState(
      user: user ?? this.user,
      isBusy: isBusy ?? this.isBusy,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}
