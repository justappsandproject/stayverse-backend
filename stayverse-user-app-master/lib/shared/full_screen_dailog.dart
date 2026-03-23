import 'package:stayverse/core/commonLibs/common_libs.dart';

Future<T?> showFullScreenDialog<T>(BuildContext context, {required Widget child}) async {
  return await Navigator.of(context).push(
    MaterialPageRoute<T>(
      fullscreenDialog: true,
      builder: (BuildContext context) => child,
    ),
  );
}
