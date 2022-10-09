
import 'package:flutter/material.dart';

import '../../../resources/dimens.dart';
import 'rounded_container.dart';

///RoundedTextField
class RoundedTextField extends StatelessWidget {
  ///Constructor
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

  ///Hint text
  final String? hintText;
  ///Icon
  final Icon? icon;
  ///onChanged function
  final Function(String)? onChanged;
  ///obscure text or not
  final bool obscureText;
  ///TextEditingController
  final TextEditingController? textEditingController;
  ///on Submit function
  final Function(String)? onSubmitted;
  ///TextInputAction
  final TextInputAction? textInputAction;
  ///FocusNode
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      color: Theme.of(context).colorScheme.secondary.withOpacity(Dimens.size02),
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
          contentPadding: EdgeInsets.zero,
          icon: Padding(
            padding: const EdgeInsets.only(left: Dimens.size16),
            child: icon,
          ),
          fillColor: Colors.transparent,
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

}