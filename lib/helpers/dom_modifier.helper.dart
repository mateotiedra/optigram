import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as dom;
import 'package:logger/logger.dart';

class DOMModifier {
  dom.Document document = dom.Document();
  final InAppWebViewController _controller;
  String? _html;

  DOMModifier(this._controller);

  Future<void> init() async {
    html = await _controller.getHtml() ?? '';
  }

  String get html => _html ?? '';

  set html(String html) => _html = html;

  void apply() {
    _controller.evaluateJavascript(source: 'document.write($html)');
  }

  void logHtml(dom.Element element) {
    Logger logger = Logger();

    logger.d(element.innerHtml);
  }
}
