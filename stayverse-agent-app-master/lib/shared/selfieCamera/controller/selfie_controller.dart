import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stayvers_agent/shared/selfieCamera/uistate/selfie_ui_state.dart';

class SelfieController extends StateNotifier<SelfieUiState> {
  SelfieController() : super(const SelfieUiState());

  Future<void> processImage( XFile image) async {
    state = state.copy(isProcessing: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copy(isProcessing: false);
  }
}

final selfieController = StateNotifierProvider<SelfieController, SelfieUiState>(
  (ref) => SelfieController(),
);
