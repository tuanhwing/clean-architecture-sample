
import 'package:flutter/material.dart';

import '../../../th_core.dart';
import '../../resources/th_dimens.dart';

///Error Popup widget
class ErrorPopUpOverlayWidget extends StatelessWidget {
  ///Constructor
  const ErrorPopUpOverlayWidget({
    Key? key,
    required this.message,
    this.title,
    this.okString,
    required this.overlayHandler,
    this.onOK,
  }) : super(key: key);
  ///Message
  final String? message;
  ///Title
  final String? title;
  ///OK string
  final String? okString;
  ///Loading/Error overlay
  final THOverlayHandler overlayHandler;
  ///onOK
  final VoidCallback? onOK;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    Widget titleWidget = const SizedBox();
    if (title != null) {
      titleWidget = Padding(
        padding: const EdgeInsets.only(
          top: THDimens.size16,
          left: THDimens.size64,
          right: THDimens.size64,
        ),
        child: Text(
          title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: themeData.textTheme.subtitle1
              ?.apply(fontSizeDelta: THDimens.size3),
        ),
      );
    }

    final double height = screenSize.height;

    return ColoredBox(
      color: themeData.primaryColorDark.withOpacity(0.1),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(THDimens.size16),
            ),
            child: Container(
              width: height,
              color: themeData.scaffoldBackgroundColor,
              constraints: const BoxConstraints(maxWidth: THDimens.size300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  titleWidget,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: THDimens.size16,
                      horizontal: THDimens.size32,
                    ),
                    child: Text(message ?? ''),
                  ),
                  Divider(
                    height: THDimens.size1,
                    color: themeData.primaryColorDark,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      overlayHandler.hide();
                      onOK?.call();
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        okString ?? tr('ok').toUpperCase(),
                        style: themeData.textTheme.subtitle1?.apply(
                          color: themeData.primaryColor,
                          fontSizeDelta: THDimens.size1,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
