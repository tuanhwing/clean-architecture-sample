import 'package:country_selection/presentation/blocs/blocs.dart';
import 'package:country_selection/utils/country_selection_defines.dart';
import 'package:th_core/th_core.dart';
import 'package:country_selection/domain/domain.dart';

///LoginBloc
class CountrySelectionBloc extends THBaseBloc<CountrySelectionEvent, CountrySelectionState> {
  ///Constructor
  CountrySelectionBloc()
      : super(const CountrySelectionState()) {
    on<CountryInitialEvent>(_onCountryInitial);
    on<SelectedCountryEvent>(_onSelected);
    on<CountryInputChangedEvent>(_onCountryInputChanged);
  }

  void _onCountryInputChanged(CountryInputChangedEvent event, Emitter<CountrySelectionState> emit) {
    if (event.text.isEmpty) {
      emit(state.copyWith(filteredCountries: state.countries.toList()));
      return;
    }
    final String text = event.text.toLowerCase();

    List<CountryCodeEntity> entities = [];
    for (var element in state.countries) {
      if (element.dialCode.toLowerCase().contains(text) || element.name.toLowerCase().contains(text)) {
        entities.add(element.copyWith());
      }
    }
    emit(state.copyWith(filteredCountries: entities));
  }

  void _onCountryInitial(CountryInitialEvent event, Emitter<CountrySelectionState> emit) async {
    List<CountryCodeEntity> entities = [];
    for (var element in CountrySelectionDefines().countries) {
      entities.add(CountryCodeEntity.fromJson(element));
    }
    emit(state.copyWith(
      selectedCountry: event.entity,
      countries: entities,
      filteredCountries: entities,
    ));
  }

  void _onSelected(SelectedCountryEvent event, Emitter<CountrySelectionState> emit) async {
    if (event.entity != state.selectedCountry) {
      emit(state.copyWith(selectedCountry: event.entity.copyWith()));

      Future.delayed(const Duration(milliseconds: 200), () {
        pageCubit.emit(CountrySelectionCompletedState(data: event.entity.copyWith()));
      });
    }
  }
}