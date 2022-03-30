
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter/material.dart';

import 'rounded_container.dart';

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    Key? key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.obscureText = false,
    this.textEditingController,
    this.onSubmitted,
    this.textInputAction,
    this.focusNode,
  }) : super(key: key);

  final String? hintText;
  final Icon? icon;
  final Function(String)? onChanged;
  final bool obscureText;
  final TextEditingController? textEditingController;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      color: Theme.of(context).colorScheme.secondary.withOpacity(Dimens.size02),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.size16),
        child: TextField(
          controller: textEditingController,
          obscureText: obscureText,
          onChanged: onChanged,
          focusNode: focusNode,
          style: Theme.of(context).textTheme.subtitle1!.apply(
            fontWeightDelta: 2
          ),
          onSubmitted: onSubmitted,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            isCollapsed: true,
            icon: icon,
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

}