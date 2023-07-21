//import 'package:Optigram/helpers/dom_modifier.helper.dart';
import 'package:optigram/views/widget/timerOpeningInsta.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//import 'package:html/dom.dart' as Dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:optigram/services/local_notice.service.dart';

const String HOME_URL = 'https://www.instagram.com/';
const String STARTING_URL = 'https://www.instagram.com/direct/inbox/';
const int OPENING_INSTA_TIME = 5;
const int WINDOW_TO_OPEN_INSTA = 60;

class InstaPage extends StatefulWidget {
  const InstaPage({super.key});

  @override
  State<InstaPage> createState() => _InstaPage();
}

class _InstaPage extends State<InstaPage> {
  final GlobalKey webViewKey = GlobalKey();

  final InAppWebViewSettings _settings = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    disableVerticalScroll: false,
    disallowOverScroll: true,
  );

  InAppWebViewController? _webViewController;

  final LocalNoticeService _localNoticeService = LocalNoticeService();

  bool _isOpening = false;
  late bool _onHomePage = false;

  void _onUrlChange(InAppWebViewController controller, WebUri? url, bool? isReload) {
    setState(() {
      String urlStr = url!.toString();
      _onHomePage = urlStr == HOME_URL;

      if (_onHomePage) {
        controller.evaluateJavascript(source: "document.body.style.overflow = 'hidden';");
      } else {
        controller.evaluateJavascript(source: "document.body.style.overflow = 'auto';");
      }
    });
  }

  void _startOpening() {
    setState(() {
      _isOpening = true;
    });
    print("add notification");

    _localNoticeService.addNotification(
      'Instagram ready',
      'Instagram is ready to be opened',
      DateTime.now().millisecondsSinceEpoch + OPENING_INSTA_TIME * 1000,
      channel: 'testing',
      id: 111,
    );

    //Future.delayed(const Duration(seconds: WINDOW_TO_OPEN_INSTA), () => _localNoticeService.cancelNotification(111));
  }

  void _cancelOpening() {
    setState(() {
      _isOpening = false;
    });
  }

  void _openingFinished() {
    setState(() {
      _isOpening = false;
    });
  }

  void _openInstagramApp() async {
    Uri url = Uri.parse(HOME_URL);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  /* void _onPageLoaded(InAppWebViewController controller, int progress) {
    if (progress != 100 || _url != 'https://www.instagram.com/') return;

    DOMModifier page = DOMModifier(controller);

    page.init().then((_) {
      Dom.Element body = page.document.getElementById('mount_0_0_p0')!;
      page.logHtml(body);
      body.attributes.putIfAbsent('style', () => 'width: 50%');
      //print(body.attributes['style']);
      page.apply();
    });
  } */

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.grey[900],
            body: Stack(children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: WebUri(STARTING_URL)),
                    initialSettings: _settings,
                    onWebViewCreated: (controller) => _webViewController = controller,
                    onUpdateVisitedHistory: _onUrlChange,
                  )),
              _onHomePage
                  ? Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 150, bottom: MediaQuery.of(context).padding.bottom + 50),
                      child: Center(
                        child: _isOpening
                            ? TimerOpeningInsta(durationInSeconds: OPENING_INSTA_TIME, onFinish: _openingFinished, onCancel: _cancelOpening)
                            : TextButton(onPressed: _startOpening, child: const Text('Open Instagram')),
                      ))
                  : Container()
            ])),
        onWillPop: () async {
          if (await _webViewController!.canGoBack()) {
            _webViewController!.goBack();
            return false;
          }
          return true;
        });
  }
}
