import 'package:flutter/material.dart';

import '../../../resources/dimens.dart';

///RoundedButton
class RoundedButton extends StatelessWidget {
  ///Constructor
  const RoundedButton({
    Key? key,
    this.radius = Dimens.size32,
    this.child,
    this.onPressed,
    this.backgroundColor,
    this.overlayColor}) : super(key: key);

  ///onPressed
  final VoidCallback? onPressed;
  ///Radius
  final double radius;
  ///Children widget
  final Widget? child;
  /// The button's background fill color.
  final MaterialStateProperty<Color?>? backgroundColor;
  /// The highlight color that's typically used to indicate that
  /// the button is focused, hovered, or pressed.
  final MaterialStateProperty<Color?>? overlayColor;

  @override
  Widget build(BuildContext context) {
    return  OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius))),
        backgroundColor: backgroundColor,
        overlayColor: overlayColor,
      ),
      child: child ?? const SizedBox()
    );
  }

}