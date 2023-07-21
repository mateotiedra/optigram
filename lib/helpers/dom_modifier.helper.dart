import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as Dom;
import 'package:logger/logger.dart';

class DOMModifier {
  Dom.Document document = Dom.Document();
  InAppWebViewController _controller;

  DOMModifier(this._controller);

  Future<void> init() async {
    document = Dom.Document.html((await _controller.getHtml())!);
    await Future.delayed(Duration(seconds: 4));
    //print("After 4 seconds : ${document.outerHtml.length}");
  }

  void apply() {
    _controller.evaluateJavascript(source: 'document.write(${document.outerHtml})');
  }

  void logHtml(Dom.Element element) {
    Logger logger = Logger();

    logger.d(element.innerHtml);
  }
}
