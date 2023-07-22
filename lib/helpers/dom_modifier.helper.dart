import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as dom;
import 'package:logger/logger.dart';

class DOMModifier {
  dom.Document document = dom.Document();
  final InAppWebViewController _controller;

  DOMModifier(this._controller);

  Future<void> init() async {
    document = dom.Document.html((await _controller.getHtml())!);
    await Future.delayed(const Duration(seconds: 4));
    //print("After 4 seconds : ${document.outerHtml.length}");
  }

  void apply() {
    _controller.evaluateJavascript(source: 'document.write(${document.outerHtml})');
  }

  void logHtml(dom.Element element) {
    Logger logger = Logger();

    logger.d(element.innerHtml);
  }
}
