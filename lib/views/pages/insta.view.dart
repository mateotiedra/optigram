//import 'package:Optigram/helpers/dom_modifier.helper.dart';
// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:optigram/controllers/timer.notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:html/dom.dart' as Dom;

import 'package:optigram/views/widget/timer_opening_insta.view.dart';
import 'package:optigram/services/local_notice.service.dart';
import 'package:optigram/services/app_lifecycle.service_observer.dart';

const String HOME_URL = 'https://www.instagram.com/';
const String STARTING_URL = 'https://www.instagram.com/direct/inbox/';
const int OPENING_INSTA_TIME = 5;
const int WINDOW_TO_OPEN_INSTA = 60;
const int NOTIFICATION_ID = 111;

class InstaPage extends StatefulWidget {
  final AppLifecycleObserver appLifecycleObserver;

  const InstaPage(this.appLifecycleObserver, {super.key});

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
    disallowOverScroll: true,
  );

  InAppWebViewController? _webViewController;

  final LocalNoticeService _localNoticeService = LocalNoticeService();
  late final AppLifecycleObserver _appLifecycleObserver = widget.appLifecycleObserver;

  Timer _timerWindowToOpen = Timer(Duration.zero, () {});

  bool _onHomePage = false;
  bool _canOpenInsta = false;
  bool _pageNotAvailable = false;

  void _onUrlChange(InAppWebViewController controller, WebUri? url, bool? isReload) {
    setState(() {
      String urlStr = url!.toString();
      _onHomePage = urlStr == HOME_URL;

      if (_onHomePage) {
        controller.evaluateJavascript(source: "document.body.style.overflow = 'hidden';");
        if (_canOpenInsta) {
          _openInstagramApp();
        }
      } else {
        controller.evaluateJavascript(source: "document.body.style.overflow = 'auto';");
      }
    });
  }

  void _startOpening() {
    Provider.of<TimerNotifier>(context, listen: false).startTimer(OPENING_INSTA_TIME, onFinish: _openingFinished);

    _localNoticeService.addNotification(
      'Instagram ready',
      'Open Instagram now',
      DateTime.now().millisecondsSinceEpoch + OPENING_INSTA_TIME * 1000,
      channel: 'Opening Instagram alert',
      id: NOTIFICATION_ID,
    );
  }

  void _cancelOpening() {
    Provider.of<TimerNotifier>(context, listen: false).cancelTimer();

    _localNoticeService.cancelNotification(NOTIFICATION_ID);
  }

  void _openingFinished() {
    setState(() {
      _canOpenInsta = true;
    });

    if (_appLifecycleObserver.userOnApp && _onHomePage) {
      _openInstagramApp();
      _localNoticeService.cancelNotification(NOTIFICATION_ID);
    } else {
      _timerWindowToOpen = Timer(const Duration(seconds: WINDOW_TO_OPEN_INSTA), () {
        setState(() {
          _canOpenInsta = false;
          _localNoticeService.cancelNotification(NOTIFICATION_ID);
        });
      });
    }
  }

  void _onResume() {
    if (_canOpenInsta) {
      _openInstagramApp();
    }
  }

  void _openInstagramApp() async {
    Uri url = Uri.parse(HOME_URL);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
    _canOpenInsta = false;
  }

  void _onReceivedError(_, __, WebResourceError err) {
    setState(() {
      _pageNotAvailable = err.type == WebResourceErrorType.HOST_LOOKUP;
    });
  }

  void _refreshPage() {
    _webViewController?.reload();
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
    _appLifecycleObserver.onResume = _onResume;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(_appLifecycleObserver);
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.grey[900],
            body: Stack(children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: _pageNotAvailable
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Instagram is not available'),
                            TextButton(onPressed: _refreshPage, child: const Text('Refresh'))
                          ],
                        ))
                      : InAppWebView(
                          key: webViewKey,
                          initialUrlRequest: URLRequest(url: WebUri(STARTING_URL)),
                          initialSettings: _settings,
                          onWebViewCreated: (controller) => _webViewController = controller,
                          onUpdateVisitedHistory: _onUrlChange,
                          onReceivedError: _onReceivedError,
                        )),
              Visibility(
                  visible: _onHomePage,
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 150, bottom: MediaQuery.of(context).padding.bottom + 50),
                      child: Center(
                        child: context.watch<TimerNotifier>().isTimerRunning
                            ? TimerOpeningInsta(
                                secondsRemaining: context.watch<TimerNotifier>().secondsRemaining, cancelTimer: _cancelOpening)
                            : TextButton(onPressed: _startOpening, child: const Text('Open Instagram')),
                      )))
            ])),
        onWillPop: () async {
          if (await _webViewController!.canGoBack()) {
            _webViewController!.goBack();
            return false;
          }
          return true;
        });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appLifecycleObserver);
    _timerWindowToOpen.cancel();
    super.dispose();
  }
}
