import 'package:stayvers_agent/core/commonLibs/common_libs.dart';

void showFullScreenDialog(BuildContext context, {required Widget child}) {
  Navigator.of(context).push(MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (BuildContext context) {
      return child;
    },
  ));
}
