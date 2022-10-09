
import 'package:flutter/material.dart';
import '../../../extensions/widget_extension.dart';

///Widget to wrap content of text
class TextSizedWidget extends StatelessWidget {
  ///Constructor
  const TextSizedWidget({
    Key? key,
    required this.textStyle,
    required this.maxString,
  }) : super(key: key);

  ///Textstyle
  final TextStyle? textStyle;
  ///Largest string value
  final String? maxString;

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    final String text = maxString ?? '';
    final TextStyle textStyle =
        _themeData.textTheme.bodyText1 ?? const TextStyle();
    final Size txtSize = getTextSize(text, textStyle);

    // This kind of use - meaningless. It's just an example.
    return SizedBox(
      width: txtSize.width,
      height: txtSize.height,
      child: Text(
        text,
        style: textStyle,
        softWrap: false,
        overflow: TextOverflow.clip,
        maxLines: 1,
      ),
    );
  }
}