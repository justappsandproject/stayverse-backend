import 'package:stayvers_agent/core/data/current_user.dart';

class DashBoardUiState {
  final bool isLoading;
  final String error;
  final int currentPageIndex;
  final CurrentUser? user;

  DashBoardUiState({
    this.isLoading = false,
    this.error = '',
    this.user,
    this.currentPageIndex = 0,
  });

  DashBoardUiState copyWith({
    bool? isLoading,
    String? error,
    CurrentUser? user,
    int? currentPageIndex,
  }) {
    return DashBoardUiState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}
