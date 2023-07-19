import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Optigram',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const InstagramWebView());
  }
}

class InstagramWebView extends StatefulWidget {
  const InstagramWebView({super.key});

  @override
  State<InstagramWebView> createState() => _InstagramWebView();
}

class _InstagramWebView extends State<InstagramWebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  InAppWebViewController? _webViewController;

  void _onTitleChanged(InAppWebViewController controller, String? title) {
    if (title != 'Instagram') return;

    //controller.evaluateJavascript(source: source)
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          body: Container(
              margin: const EdgeInsets.only(top: 50),
              child: InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri('https://www.instagram.com/')),
                initialSettings: settings,
                onWebViewCreated: (controller) => _webViewController = controller,
                onTitleChanged: _onTitleChanged,
              )),
        ),
        onWillPop: () async {
          if (await _webViewController!.canGoBack()) {
            _webViewController!.goBack();
            return false;
          }
          return true;
        });
  }
}
