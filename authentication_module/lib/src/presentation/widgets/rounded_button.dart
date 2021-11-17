import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter/material.dart';

import 'rounded_container.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    this.title,
    this.onPressed,
    this.textColor}) : super(key: key);

  final String? title;
  final VoidCallback? onPressed;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.size16),
          child: Text(
            title ?? "",
            style: Theme.of(context).textTheme.subtitle1!.apply(
              color: textColor,
              fontWeightDelta: 2,
            ),
          ),
        ),
      ),
    );
  }

}