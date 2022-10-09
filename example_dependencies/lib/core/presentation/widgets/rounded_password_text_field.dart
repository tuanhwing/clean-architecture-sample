
import 'package:flutter/material.dart';

import '../../../resources/dimens.dart';
import 'rounded_container.dart';

///RoundedPasswordTextField
class RoundedPasswordTextField extends StatefulWidget {
  ///Constructor
  const RoundedPasswordTextField({
    Key? key,
    this.hintText,
    this.textEditingController,
    this.onSubmitted,
    this.textInputAction,
    this.focusNode,
  }) : super(key: key);

  ///Hint text
  final String? hintText;
  ///TextEditingController
  final TextEditingController? textEditingController;
  ///on Submit function
  final Function(String)? onSubmitted;
  ///TextInputAction
  final TextInputAction? textInputAction;
  ///Focus node
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
                contentPadding: EdgeInsets.zero,
                icon: const Padding(
                  padding: EdgeInsets.only(left: Dimens.size16),
                  child: Icon(
                    Icons.lock_rounded
                  ),
                ),
                fillColor: Colors.transparent,
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
            child: Padding(
              padding: const EdgeInsets.only(
                left: Dimens.size4,
                right: Dimens.size16,
              ),
              child: Icon(
                _obscureText
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye),
            ),
          )
        ],
      ),
    );
  }

}