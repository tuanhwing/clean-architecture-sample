
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter/material.dart';

class HeaderAuthenticationWidget extends StatelessWidget {
  const HeaderAuthenticationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
          vertical: Dimens.size32
      ),
      child: Icon(
        Icons.android,
        size: Dimens.size64,
      ),
    );
  }

}