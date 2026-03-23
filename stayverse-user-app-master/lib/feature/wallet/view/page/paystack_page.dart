import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/shared/skeleton.dart';
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
              $navigate.backWithParameters(
                  args: request.url.contains('/cancel') ? false : true);
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
        title: Text(
          'Wallet',
          style: $styles.text.body.copyWith(
            color: $styles.colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: WebViewWidget(controller: _controller),
      isBusy: false,
    );
  }
}
