import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:flutter/foundation.dart';

enum _LoadingStatus { loading, stable }

class LazyLoadScrollView extends StatefulWidget {
  const LazyLoadScrollView({
    super.key,
    required this.child,
    this.onStartOfPage,
    this.onEndOfPage,
    this.showLoadinIndicator = true,
    this.allowedAxis = const [Axis.horizontal, Axis.vertical],
    this.scrollOffset = 100,
  });

  final Widget child;

  final bool showLoadinIndicator;
  final AsyncCallback? onStartOfPage;

  final AsyncCallback? onEndOfPage;

  final double scrollOffset;

  ///Usefull when you have more than one scroll widget
  ///with dirrent scroll direction
  ///[allowedAxis] allow you specify which list is allow to update the [onStartOfPage]/[onEndOfPage]
  final List<Axis> allowedAxis;

  @override
  State<StatefulWidget> createState() => _LazyLoadScrollViewState();
}

class _LazyLoadScrollViewState extends State<LazyLoadScrollView> {
  var _loadMoreStatus = _LoadingStatus.stable;
  double _scrollPosition = 0;

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
        onNotification: _onNotification,
        child: Column(
          children: [
            Expanded(child: widget.child),

            ///A loading indicator that show when item is loading
            if (_loadMoreStatus == _LoadingStatus.loading &&
                widget.showLoadinIndicator)
              const LinearProgressIndicator(
                minHeight: 2.5,
                valueColor: AlwaysStoppedAnimation(Colors.white),
                backgroundColor: Colors.transparent,
              )
          ],
        ),
      );

  ///Notify when there is a drag
  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification &&
        notification.dragDetails != null) {
      final pixels = notification.metrics.pixels;
      final scrollOffset = widget.scrollOffset;
      final extentBefore = notification.metrics.extentBefore;
      final extentAfter = notification.metrics.extentAfter;
      final scrollingDown = _scrollPosition < pixels;
      _scrollPosition = pixels;

      // Determine the scroll direction
      Axis scrollDirection = notification.metrics.axis;

      if (!(widget.allowedAxis.contains(scrollDirection))) {
        return false;
      }

      if (scrollingDown) {
        if (extentAfter <= scrollOffset) {
          _onEndOfPage();
          return true;
        }
      } else {
        if (extentBefore <= scrollOffset) {
          _onStartOfPage();
          return true;
        }
      }
    }
    if (notification is OverscrollNotification) {
      if (notification.overscroll > 0) {
        _onEndOfPage();
      }
      if (notification.overscroll < 0) {
        _onStartOfPage();
      }
      return true;
    }
    return false;
  }

  ///Update the scroll
  ///show indicator that there is a scroll then update itself when the scroll us over
  ///when the user get to the end of the page
  void _onEndOfPage() {
    if (_loadMoreStatus == _LoadingStatus.stable) {
      if (widget.onEndOfPage != null) {
        setState(() => _loadMoreStatus = _LoadingStatus.loading);
        widget.onEndOfPage!().whenComplete(() {
          setState(() => _loadMoreStatus = _LoadingStatus.stable);
        });
      }
    }
  }

  ///when the user get to the top of the page
  void _onStartOfPage() {
    if (_loadMoreStatus == _LoadingStatus.stable) {
      if (widget.onStartOfPage != null) {
        setState(() => _loadMoreStatus = _LoadingStatus.loading);
        widget.onStartOfPage!().whenComplete(() {
          setState(() => _loadMoreStatus = _LoadingStatus.stable);
        });
      }
    }
  }
}
