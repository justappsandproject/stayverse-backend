import '../../../../../core/commonLibs/common_libs.dart';

/// SignUpUiState represents the UI state for the SignUp page
@immutable
class ChatUiState {
  const ChatUiState({
    this.isBusy = false,
    this.errorMsg = '',
  });

  final bool isBusy;
  final String errorMsg;

  ChatUiState copy({
    bool? isBusy,
    String? errorMsg,
  }) {
    return ChatUiState(
      isBusy: isBusy ?? this.isBusy,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
