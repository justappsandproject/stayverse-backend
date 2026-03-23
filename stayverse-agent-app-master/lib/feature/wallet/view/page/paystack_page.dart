import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/shared/skeleton.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayStackPage extends StatefulWidget {
  final String url;
  static const route = '/PayStackPage';

  const PayStackPage({
    super.key,
    required this.url,
  });

  @override
  State<PayStackPage> createState() => _PayStackPage();
}

class _PayStackPage extends State<PayStackPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://stayverse.com')) {
              $navigate.back();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: 'Wallet'.txt20(
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
      body: WebViewWidget(controller: _controller),
      isBusy: false,
    );
  }
}
