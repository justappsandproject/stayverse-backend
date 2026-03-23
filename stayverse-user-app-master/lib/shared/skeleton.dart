import 'package:gif/gif.dart';
import 'package:stayverse/core/util/app/loading.dart';
import 'package:stayverse/core/util/image/app_assets.dart';

import '../core/commonLibs/common_libs.dart';

/// A skeleton widget that provides a basic structure for pages in the app.
class BrimSkeleton extends StatelessWidget {
  final bool? isBusy;
  final bool? automaticallyImplyLeading;
  final Color? backgroundColor;
  final String? appBarTitle;
  final TextStyle? appBarTitleStyle;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? belowOverlayChild;
  final List<Widget>? appBarActions;
  final Widget? appBarLeading;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final EdgeInsets? bodyPadding;
  final Widget? appBarTitleWidget;
  final BoxConstraints? constraints;
  final bool? centerTitle;
  final String? busyText;
  final double? leadingWidth;
  final PreferredSizeWidget? appBar;
  final bool? isAuthSkeleton;

  const BrimSkeleton({
    super.key,
    required this.body,
    this.isBusy,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.appBarTitle,
    this.appBarTitleStyle,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.floatingActionButtonLocation,
    this.belowOverlayChild,
    this.appBarActions,
    this.appBarLeading,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.bodyPadding,
    this.appBarTitleWidget,
    this.constraints,
    this.centerTitle = false,
    this.busyText,
    this.leadingWidth,
    this.appBar,
    this.isAuthSkeleton = false,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      opacity: 0,
      color: Colors.black.withOpacity(0.6),
       progressIndicator: SizedBox(
        height: 80.h,
        width: 80.w,
        child: Gif(
          image: AssetImage(AppAsset.laodingGif),
          autostart: Autostart.loop,
        ),
      ),
      isLoading: isBusy ?? false,
      child: IgnorePointer(
        ignoring: isBusy ?? false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: isAuthSkeleton,
            backgroundColor: backgroundColor,
            appBar: appBar,
            body: Container(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              padding:
                  bodyPadding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: body,
            ),
            floatingActionButton: floatingActionButton,
            floatingActionButtonAnimator: floatingActionButtonAnimator,
            floatingActionButtonLocation: floatingActionButtonLocation,
            drawer: drawer,
            endDrawer: endDrawer,
            bottomNavigationBar: bottomNavigationBar,
            bottomSheet: bottomSheet,
          ),
        ),
      ),
    );
  }
}
