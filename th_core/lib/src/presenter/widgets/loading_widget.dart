
import 'package:flutter/material.dart';

///Loading widget
class LoadingWidget extends StatelessWidget {
  ///Constructor
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return  ColoredBox(
      color: themeData.primaryColorDark.withOpacity(0.1),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeData.primaryColor),
        ),
      ),
    );
  }
}
