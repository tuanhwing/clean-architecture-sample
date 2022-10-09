
import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart';

///AlreadyHaveAnAccountWidget
class AlreadyHaveAnAccountWidget extends StatelessWidget {
  ///Constructor
  const AlreadyHaveAnAccountWidget(
      {Key? key, required this.title, required this.subTitle, this.onTap})
      : super(key: key);
  ///Title
  final String title;
  ///onTap
  final VoidCallback? onTap;
  ///subTitle
  final String subTitle;


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: themeData.textTheme.subtitle2,
        ),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Dimens.size16,
              horizontal: Dimens.size8
            ),
            child: Text(
              subTitle,
              style: themeData.textTheme.subtitle2!.apply(
                color: themeData.colorScheme.secondary,
                fontWeightDelta: 2
              ),
            ),
          ),
        )
      ],
    );
  }
}