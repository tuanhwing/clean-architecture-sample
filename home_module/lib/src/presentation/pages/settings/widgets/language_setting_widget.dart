import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart';

///LanguageSettingWidget
class LanguageSettingWidget extends StatelessWidget {
  ///Constructor
  const LanguageSettingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = GetIt.I.get<AppBloc>();
    ThemeData themeData = Theme.of(context);

    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Dimens.size4,
            ),
            child: Text(
              tr('language').inCaps,
              style: themeData.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),),
          ),
          Divider(
              color: themeData.disabledColor
          ),
          ...appBloc.state.languages
              .map((String e) => _LanguageItemWidget(
            languageCode: e,
          ))
              .toList()
        ],
      ),
    );
  }
}

class _LanguageItemWidget extends StatelessWidget {
  const _LanguageItemWidget({
    Key? key,
    required this.languageCode,
  }) : super(key: key);

  ///Language code
  final String languageCode;

  void _changeLanguage(String currentLocaleString, BuildContext context) {
    if (currentLocaleString == languageCode) return;
    Navigator.of(context).pop(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    String localeString = context.locale.toString();

    return InkWell(
      onTap: () => _changeLanguage(localeString, context),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.size16,
          vertical: Dimens.size8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(tr(languageCode).capitalizeFirsTofEach),
            ),
            Icon(localeString == languageCode
                ? Icons.radio_button_checked
                : Icons.radio_button_off)
          ],
        ),
      ),
    );
  }
}
