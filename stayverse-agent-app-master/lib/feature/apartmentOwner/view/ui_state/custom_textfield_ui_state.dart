import 'package:flutter_riverpod/flutter_riverpod.dart';

final textFieldProvider = StateNotifierProvider.family<TextFieldNotifier, String, String>(
  (ref, semanticLabel) => TextFieldNotifier(''),
);

class TextFieldNotifier extends StateNotifier<String> {
  // ignore: use_super_parameters
  TextFieldNotifier(String initialValue) : super(initialValue);

  void updateText(String value) {
    state = value;
  }
}