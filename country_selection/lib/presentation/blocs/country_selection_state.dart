import 'package:country_selection/domain/domain.dart';
import 'package:th_core/th_core.dart';

///CountrySelectionState
class CountrySelectionState extends Equatable {
  ///Constructor
  const CountrySelectionState({
    this.countries = const [],
    this.filteredCountries = const [],
    this.selectedCountry,
  });

  ///List of countries
  final List<CountryCodeEntity> countries;
  ///List of filtered countries
  final List<CountryCodeEntity> filteredCountries;
  ///Variable hold country info which selected
  final CountryCodeEntity? selectedCountry;

  ///Return new instance of CountrySelectionState
  CountrySelectionState copyWith({
    List<CountryCodeEntity>? countries,
    List<CountryCodeEntity>? filteredCountries,
    CountryCodeEntity? selectedCountry,
  }) {
    return CountrySelectionState(
      countries: countries ?? this.countries,
      filteredCountries: filteredCountries ?? this.filteredCountries,
      selectedCountry: selectedCountry ?? this.selectedCountry,
    );
  }

  @override
  List<Object?> get props => [countries, filteredCountries, selectedCountry];
}

///CountrySelectionCompletedState
class CountrySelectionCompletedState extends THWidgetState<CountryCodeEntity> {
  ///Constructor
  const CountrySelectionCompletedState({
    required super.data,
  });
}