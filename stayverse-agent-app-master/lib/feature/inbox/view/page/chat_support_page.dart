import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/skeleton.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatSupportPage extends StatefulWidget {
  static const route = '/ChatSupportPage';
  const ChatSupportPage({super.key, required this.url});

  final String url;

  @override
  State<ChatSupportPage> createState() => _ChatSupportPageState();
}

class _ChatSupportPageState extends State<ChatSupportPage> {
  late WebViewController _controller;
  bool _isLoading = true;

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
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isAuthSkeleton: false,
      backgroundColor: Colors.white,
      bodyPadding: EdgeInsets.zero,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: const AppBackButton(),
        title: const Text(
          'Chat Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
