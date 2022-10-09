
import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart';

///AuthenticationHeaderWidget
class AuthenticationHeaderWidget extends StatelessWidget {
  ///Counstructor
  const AuthenticationHeaderWidget({
    Key? key,
    this.title,
    this.description,
  }) : super(key: key);

  ///Title
  final String? title;
  ///Description
  final String? description;

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title != null ? Text(
          title!,
          style: _themeData.textTheme.bodyText1?.copyWith(
              color: _themeData.hintColor
          ),
        ) : const SizedBox(),
        const SizedBox(height: Dimens.size4,),
        description != null ? Text(
          description!,
          style: _themeData.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold
          ),
        ) : const SizedBox(),
      ],
    );
  }
}
