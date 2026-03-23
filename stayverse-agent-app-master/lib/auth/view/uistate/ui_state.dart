

class TestUiState {
  final bool isLoading;
  final String? error;

  TestUiState({required this.isLoading, this.error});

  TestUiState copyWith({bool? isLoading, String? error}) {
    return TestUiState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}