import 'package:stayvers_agent/core/service/BrimDecoders/decoders_list.dart';

class BrimDecoders {
  /// Return an object from your modelDecoders using [data].
  static T dataToModel<T>(
      {required dynamic data, Map<Type, dynamic>? modelDecoders}) {
    assert(T != dynamic,
        "You must provide a Type from your modelDecoders from within your config/decoders.dart file");
    if (modelDecoders != null && (modelDecoders.isNotEmpty)) {
      assert(
          modelDecoders.containsKey(T), "ModelDecoders not found for Type: $T");
      return modelDecoders[T](data);
    }

    Map<Type, dynamic> mainDecoders = BrimDecoratorsList.decorators;
    assert(mainDecoders.containsKey(T),
        "Your modelDecoders variable inside decoders_list.dart must contain a decoder for Type: $T");
    return mainDecoders[T](data);
  }
}
