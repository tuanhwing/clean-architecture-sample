
import 'package:flutter/material.dart';
import 'package:th_dependencies/th_dependencies.dart';

import '../../extensions/extensions.dart';
import '../../resources/th_dimens.dart';

///Failure widget
class FailureWidget extends StatelessWidget {
  ///Constructor
  const FailureWidget(
      {Key? key, this.errorMessage, this.titleButton, this.onRetry,})
      : super(key: key);

  ///Error message
  final String? errorMessage;
  ///Title button
  final String? titleButton;
  ///Retry callback
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/error.png', package: 'th_core',),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(THDimens.size24),
          child: Text(
            '${errorMessage ?? tr('something_went_wrong').inCaps} :(',
            style: themeData.textTheme.headline6!
                .apply(color: themeData.primaryColor),
            textAlign: TextAlign.center,
          ),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
              textStyle: themeData.textTheme.headline6!
                  .apply(color: themeData.primaryColor),),
          onPressed: onRetry,
          child: Text(titleButton ?? tr('retry').inCaps),
        ),
      ],
    );
  }
}
