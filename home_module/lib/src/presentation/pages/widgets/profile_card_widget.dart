
import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart';

///ProfileCardWidget
class ProfileCardWidget extends StatelessWidget {
  ///Constructor
  const ProfileCardWidget({Key? key, required this.user}) : super(key: key);
  ///User information
  final User? user;

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Column(
      children: <Widget>[
        const SizedBox(height: Dimens.size40,),
        CircleAvatar(
          radius: Dimens.size64,
          backgroundColor: _theme.disabledColor,
          backgroundImage: const NetworkImage(MockUp.avatarURL),
        ),
        const SizedBox(height: Dimens.size16,),
        Text(user?.name ?? '', style: _theme.textTheme.headline6,),
        const SizedBox(height: Dimens.size4,),
        Text(
          user?.phone.fullPhoneNumber ?? '...',
          style:
              _theme.textTheme.bodyText2?.copyWith(color: _theme.disabledColor),
        ),
      ],
    );
  }
}
