
import 'package:example_dependencies/resources/dimens.dart';
import 'package:flutter/material.dart';

import 'rounded_container.dart';

class RoundedPasswordTextField extends StatefulWidget {
  const RoundedPasswordTextField({
    Key? key,
    this.hintText,
    this.textEditingController,
    this.onSubmitted,
    this.textInputAction,
    this.focusNode,
  }) : super(key: key);

  final String? hintText;
  final TextEditingController? textEditingController;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  State<StatefulWidget> createState() => _RoundedPasswordTextFieldState();

}

class _RoundedPasswordTextFieldState extends State<RoundedPasswordTextField> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      color: Theme.of(context).colorScheme.secondary.withOpacity(Dimens.size02),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.size16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: widget.textEditingController,
                obscureText: _obscureText,
                focusNode: widget.focusNode,
                textInputAction: widget.textInputAction,
                onSubmitted: widget.onSubmitted,
                style: Theme.of(context).textTheme.subtitle1!.apply(
                    fontWeightDelta: 2
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  icon: const Icon(
                    Icons.lock_rounded
                  ),
                  hintText: widget.hintText,
                  border: InputBorder.none,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.remove_red_eye_outlined : Icons.remove_red_eye
              ),
            )
          ],
        ),
      ),
    );
  }

}