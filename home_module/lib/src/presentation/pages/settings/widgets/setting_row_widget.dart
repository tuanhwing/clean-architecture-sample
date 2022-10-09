
import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart';

///SettingRowWidget
class SettingRowWidget extends StatelessWidget {
  ///Constructor
  const SettingRowWidget({
    Key? key,
    required this.iconData,
    required this.title,
    this.value,
    this.iconNextData,
    this.onTap,
  }) : super(key: key);

  ///IconData
  final IconData iconData;
  ///IconData
  final IconData? iconNextData;
  ///Title
  final String title;
  ///Value
  final String? value;
  ///onTap
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.size8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(Dimens.size8),
              decoration: BoxDecoration(
                color: _theme.highlightColor,
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimens.size12))
              ),
              child: Icon(
                iconData,
              ),
            ),
            const SizedBox(width: Dimens.size8,),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: _theme.textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.bold),
              ),
            ),
            value != null && value!.isNotEmpty ? Text(
              value!,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: _theme.textTheme.bodyText2,
            ) : const SizedBox(),
            iconNextData != null ? Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.size8),
              child: Icon(
                iconNextData!,
              ),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
