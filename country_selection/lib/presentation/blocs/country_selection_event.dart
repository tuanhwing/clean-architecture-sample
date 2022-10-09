
import 'package:country_selection/domain/domain.dart';
import 'package:th_core/th_core.dart';

///Abstract class country_selection event
abstract class CountrySelectionEvent extends Equatable {
  ///Constructor
  const CountrySelectionEvent();

  @override
  List<Object?> get props => <Object?>[];
}

///CountryInitialEvent
class CountryInitialEvent extends CountrySelectionEvent {
  ///Constructor
  const CountryInitialEvent({this.entity}) : super();

  final CountryCodeEntity? entity;

  @override
  List<Object?> get props => <Object?>[];
}

///SelectedCountryEvent
class SelectedCountryEvent extends CountrySelectionEvent {
  ///Constructor
  const SelectedCountryEvent({
    required this.entity,
  }) : super();
  final CountryCodeEntity entity;

  @override
  List<Object?> get props => <Object?>[entity];
}

///CountryInputChangedEvent
class CountryInputChangedEvent extends CountrySelectionEvent {
  ///Constructor
  const CountryInputChangedEvent({
    required this.text,
  }) : super();
  final String text;

  @override
  List<Object?> get props => <Object?>[text];
}