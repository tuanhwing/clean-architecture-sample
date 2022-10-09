import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:example_dependencies/core/core.dart';
import 'package:example_dependencies/resources/dimens.dart';
import 'package:th_core/th_core.dart';

import '../../blocs/blocs.dart';
import '../widgets/widgets.dart';
import './widgets/widgets.dart';

///Setting page
class SettingsPage extends StatefulWidget {
  ///Constructor
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends THState<SettingsPage, SettingsBloc> {

  HomeBloc get _homeBloc => BlocProvider.of<HomeBloc>(context);

  void _showDialogConfirmLogin() async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      builder: (_) => CupertinoAlertDialog(
        title: Text(tr('logout_confirm').inCaps),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(tr('no').inCaps),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: Text(tr('yes').inCaps),
            onPressed: () => _homeBloc.add(const LogoutEvent()),
          )
        ],
      )
    );
  }

  void _showLanguageSetting() async {
    String currentLocaleString = context.locale.toString();
    String? localeString = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: Theme.of(context).selectedRowColor,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(Dimens.size32),
            topLeft: Radius.circular(Dimens.size32),
          ),
        ),
        builder: (BuildContext context) {
          return const BottomSheetWidget(
            wrapContent: true,
            child: LanguageSettingWidget(),
          );
        });
    if (localeString != null && currentLocaleString != localeString) {
      context.setLocale(Locale(localeString));
    }
  }

  @override
  void onRetry() {
    bloc.add(const SettingInitializationEvent());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void onPageStateChanged(THWidgetState<dynamic> state) {
    super.onPageStateChanged(state);

    THLogger().d('onPageStateChanged $state');
  }

  @override
  Widget get content {
    String locale = context.locale.toString();
    ThemeData _theme = Theme.of(context);

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            BlocBuilder<AppBloc, AppState>(
              buildWhen: (AppState previous, AppState current) =>
              previous.user != current.user,
              builder: (_, AppState state) {
                return Column(
                  children: <Widget>[
                    ProfileCardWidget(user: state.user,)
                  ],
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(Dimens.size16),
              child: Divider(
                  color: _theme.disabledColor
              ),
            ),

            const AdditionalInfoWidget(),
            const SizedBox(height: Dimens.size40,),

            Container(
              padding: const EdgeInsets.all(Dimens.size16),
              margin: const EdgeInsets.symmetric(
                vertical: Dimens.size16,
                horizontal: Dimens.size4,
              ),
              decoration: BoxDecoration(
                color: _theme.highlightColor.withOpacity(0.2),
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimens.size32))
              ),
              child: Column(
                children: <Widget>[
                  SettingRowWidget(
                    iconData: Icons.notifications,
                    title: tr('notification').inCaps,
                    iconNextData: Icons.navigate_next,
                    onTap: () {},
                  ),
                  SettingRowWidget(
                    iconData: Icons.language,
                    title: tr('language').inCaps,
                    value: tr(locale).capitalizeFirsTofEach,
                    iconNextData: Icons.navigate_next,
                    onTap: _showLanguageSetting,
                  ),
                  SettingRowWidget(
                    iconData: Icons.bookmark_outline,
                    title: tr('history').inCaps,
                    iconNextData: Icons.navigate_next,
                    onTap: () {},
                  ),
                  Divider(
                    color: _theme.disabledColor
                  ),
                  SettingRowWidget(
                    iconData: Icons.help,
                    title: tr('help').inCaps,
                    iconNextData: Icons.navigate_next,
                    onTap: () {},
                  ),
                  SettingRowWidget(
                    iconData: Icons.logout,
                    title: tr('log_out').inCaps,
                    iconNextData: Icons.navigate_next,
                    onTap: _showDialogConfirmLogin,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

