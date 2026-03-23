import 'package:flutter/foundation.dart';

@immutable
class SelfieUiState {
  const SelfieUiState({
    this.isProcessing = false,
  });

  final bool isProcessing;

  SelfieUiState copy({
    bool? isProcessing,
  }) {
    return SelfieUiState(
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}
