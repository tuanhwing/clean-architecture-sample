
import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart';

class AlreadyHaveAnAccountWidget extends StatelessWidget {
  const AlreadyHaveAnAccountWidget({Key? key, required this.title, required this.subTitle, this.onTap}) : super(key: key);
  final String title;
  final VoidCallback? onTap;
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