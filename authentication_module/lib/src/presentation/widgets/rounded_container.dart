
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({Key? key, required this.child, this.color}) : super(key: key);

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.size32),
      child: Container(
        width: double.infinity,
        color: color,
        child: child,
      )
    );
  }

}
