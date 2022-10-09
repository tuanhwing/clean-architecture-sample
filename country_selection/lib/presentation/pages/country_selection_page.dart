
import 'dart:async';

import 'package:country_selection/country_selection.dart';
import 'package:country_selection/presentation/widgets/countries_widget.dart';
import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart';

class CountrySelectionPage extends StatefulWidget {
  const CountrySelectionPage({
    Key? key,
    this.initialCountryCodeEntity,
  }) : super(key: key);
  final CountryCodeEntity? initialCountryCodeEntity;

  @override
  _CountrySelectionPageState createState() => _CountrySelectionPageState();
}

class _CountrySelectionPageState extends THState<CountrySelectionPage, CountrySelectionBloc> {
  final TextEditingController _searchTEC = TextEditingController();
  Timer? _debounce;

  @override
  Color? get backgroundColor => Colors.transparent;

  @override
  void initState() {
    super.initState();
    bloc.add(CountryInitialEvent(entity: widget.initialCountryCodeEntity));
    _searchTEC.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        bloc.add(CountryInputChangedEvent(text: _searchTEC.text));
      });

    });
  }

  @override
  void dispose() {
    _searchTEC.dispose();
    _debounce?.cancel();

    super.dispose();
  }

  @override
  void onPageStateChanged(THWidgetState state) {
    super.onPageStateChanged(state);

    if (state is CountrySelectionCompletedState) {
      Navigator.of(context).pop(state.data);
    }
  }

  @override
  Widget get content => Column(
    children: <Widget>[
      const SizedBox(height: Dimens.size16),
      Text(
        tr('select_a_country').inCaps,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      Padding(
        padding: const EdgeInsets.all(Dimens.size16),
        child: _CountrySearchTextField(
          controller: _searchTEC,
        ),
      ),
      const Expanded(
        child: CountriesWidget(),
      ),
    ],
  );
}

class _CountrySearchTextField extends StatelessWidget {
  const _CountrySearchTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        focusColor: Colors.transparent,
        prefixIcon: const Icon(
          Icons.search
        ),
        hintText: tr('search').inCaps,
      ),
    );
  }
}