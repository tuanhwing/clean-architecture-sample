
import 'package:flutter/material.dart';

///CountryCodeWidget
class CountryCodeWidget extends StatelessWidget {
  ///CountryCodeWidget
  const CountryCodeWidget({
    Key? key,
    this.onTap,
    required this.code,
  }) : super(key: key);
  ///Callback when received on onTap
  final VoidCallback? onTap;
  ///Code of country
  final String code;



  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Text(
            code,
            style: _themeData.textTheme.titleLarge?.copyWith(
                color: _themeData.colorScheme.onBackground
            ),
          ),
          Icon(
            Icons.expand_more_rounded,
            color: _themeData.hintColor,
          ),
        ],
      ),
    );
  }
}
