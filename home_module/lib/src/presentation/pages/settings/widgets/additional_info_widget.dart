
import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart';

///AdditionalInfoWidget
class AdditionalInfoWidget extends StatelessWidget {
  ///Constructor
  const AdditionalInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Expanded(
          child: _InfoWidget(
            title: 'Check-in',
            value: '131'
          ),
        ),
        Expanded(
          child: _InfoWidget(
            title: 'Warnings',
            value: '142'
          ),
        ),
        Expanded(
          child: _InfoWidget(
            title: 'Journeys',
            value: '1210'
          ),
        ),
      ],
    );
  }
}

class _InfoWidget extends StatelessWidget {
  const _InfoWidget({
    Key? key,
    required this.value,
    required this.title,
  }) : super(key: key);
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Text(
          value,
          style:
              _theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: Dimens.size4),
        Text(
          title,
          style: _theme.textTheme.caption?.copyWith(
              color: _theme.disabledColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
