
import 'package:country_selection/domain/domain.dart';
import 'package:country_selection/presentation/blocs/blocs.dart';
import 'package:country_selection/utils/country_selection_defines.dart';
import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart';

class CountriesWidget extends StatelessWidget {
  const CountriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountrySelectionBloc, CountrySelectionState>(
      buildWhen: (previous, current) => previous.filteredCountries != current.filteredCountries,
      builder: (_, state) {
        if (state.filteredCountries.isEmpty) {
          return const _EmptyCountriesWidget();
        }
        return ListView.builder(
          itemCount: state.filteredCountries.length,
          itemBuilder: (_, index) {
            return _CountryItemWidget(entity: state.filteredCountries[index]);
          },
        );
      },
    );
  }
}

class _CountryItemWidget extends StatelessWidget {
  const _CountryItemWidget({
    Key? key,
    required this.entity,
  }) : super(key: key);
  final CountryCodeEntity entity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountrySelectionBloc, CountrySelectionState>(
      buildWhen: (previous, current) => previous.selectedCountry != current.selectedCountry,
      builder: (_, state) {
        return InkWell(
          onTap: () => context.read<CountrySelectionBloc>().add(SelectedCountryEvent(entity: entity)),
          child: Container(
            decoration: state.selectedCountry?.code == entity.code ? BoxDecoration(
              color: Theme.of(context).highlightColor,
            ) : null,
            padding: const EdgeInsets.all(Dimens.size8),
            child: Row(
              children: [
                SizedBox(
                  width: Dimens.size32,
                  child: Image.asset(
                    CountrySelectionDefines.flagsAssetsPath + entity.code.toLowerCase() + '.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(width: Dimens.size8,),
                Expanded(
                  child: Text(
                    entity.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ),
                Text(
                  entity.dialCode,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyCountriesWidget extends StatelessWidget {
  const _EmptyCountriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.search_off),
        const SizedBox(width: Dimens.size4,),
        Text(
          tr("could_not_find_any_element").inCaps,
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    );
  }
}


