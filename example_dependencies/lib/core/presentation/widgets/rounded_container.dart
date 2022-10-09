
import 'package:flutter/material.dart';

import '../../../resources/dimens.dart';

///RoundedContainer
class RoundedContainer extends StatelessWidget {
  ///Constructor
  const RoundedContainer({Key? key, required this.child, this.color})
      : super(key: key);

  ///Child widget
  final Widget child;
  ///Color of container
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
