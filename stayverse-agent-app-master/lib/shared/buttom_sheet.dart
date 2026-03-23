import 'package:stayvers_agent/core/extension/extension.dart';

import '../core/commonLibs/common_libs.dart';

Future<void> showAppBottomSheet(BuildContext context, Widget widget,
    {Color? sheetColor,
    bool dismissible = true,
    EdgeInsets? edgeInsets,
    bool enableDrag = true,
    double? radius,
    Color overlayColor = Colors.black54}) {
  return showModalBottomSheet<void>(
    isDismissible: dismissible,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: enableDrag,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return Stack(
          children: [
            ModalBarrier(
              dismissible: dismissible,
              color: overlayColor,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: edgeInsets ?? EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: sheetColor ?? Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius ?? 20),
                    topRight: Radius.circular(radius ?? 20),
                  ),
                ),
                child: Center(
                  child: widget,
                ),
              ),
            ),
          ],
        );
      });
    },
  );
}

Future<void> showNormalButtomSheet(BuildContext context, Widget widget,
    {bool dismissible = false,
    BorderRadius? borderRadius,
    Color? barrierColor,
    EdgeInsets? margin}) {
  return showModalBottomSheet<void>(
    isDismissible: dismissible,
    enableDrag: true,
    backgroundColor:Colors.transparent,
    isScrollControlled: true,
    barrierColor: barrierColor ?? Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return SingleChildScrollView(
          child: Wrap(
            children: [
              Container(
                margin: margin ?? EdgeInsets.zero,
                padding: EdgeInsets.zero,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: context.color.primary,
                  borderRadius: borderRadius ??
                      BorderRadius.only(
                          topLeft: Radius.circular(21.0.r),
                          topRight: Radius.circular(21.0.r)),
                ),
                child: Center(
                  child: widget,
                ),
              ),
            ],
          ),
        );
      });
    },
  );
}

void showFullScreenDialog(BuildContext context, {required Widget child}) {
  Navigator.of(context).push(MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (BuildContext context) {
      return child;
    },
  ));
}
