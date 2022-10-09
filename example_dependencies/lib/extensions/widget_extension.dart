
import 'package:flutter/cupertino.dart';

///WidgetExtension
extension WidgetExtension on Widget {

  /// Return size of text with style
  ///
  /// [text] value string of text
  /// [style] style of text
  Size getTextSize(String text, TextStyle? style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}