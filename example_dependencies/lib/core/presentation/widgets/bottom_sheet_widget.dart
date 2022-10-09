
import 'package:flutter/material.dart';

import '../../../resources/dimens.dart';

///BottomSheet content widget
class BottomSheetWidget extends StatelessWidget {
  ///Constructor
  const BottomSheetWidget({
    Key? key,
    required this.child,
    this.height,
    this.wrapContent = false,
  }) : super(key: key);

  ///Height of bottom sheet
  final double? height;
  ///Child widget
  final Widget child;
  ///Wrap content
  final bool wrapContent;



  @override
  Widget build(BuildContext context) {
    return !wrapContent ? SizedBox(
      height: height ?? MediaQuery.of(context).size.height * Dimens.size09,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(Dimens.size8),
            child: _BottomSheetTopWidget(),
          ),
          Expanded(child: child),
        ],
      ),
    ) : SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(Dimens.size8),
            child: _BottomSheetTopWidget(),
          ),
          child,
        ],
      ),
    );
  }
}

class _BottomSheetTopWidget extends StatelessWidget {
  const _BottomSheetTopWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.size4,
      width: Dimens.size32,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(Dimens.size2)
        ),
        color: Theme.of(context).hintColor
      ),
    );
  }
}

