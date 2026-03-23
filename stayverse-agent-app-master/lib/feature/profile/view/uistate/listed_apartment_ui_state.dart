import 'package:fixed_collections/fixed_collections.dart';
import 'package:stayvers_agent/feature/apartmentOwner/model/data/apartment_response.dart';

class ListedApartmentUiState {
  const ListedApartmentUiState({
    this.isBusy = false,
    this.isLoading= false,
    List<Apartment>? apartments,

  })  : _apartments = apartments;

 final bool isBusy;

  // Loading state

  final bool isLoading;

    // listed data

  final List<Apartment>? _apartments;

  FixedList<Apartment> get apartments => FixedList(_apartments ?? []);

  ListedApartmentUiState copyWith({
    bool? isBusy,
    bool? isLoading,
    List<Apartment>? apartments,
  }) {
    return ListedApartmentUiState(
       isBusy: isBusy ?? this.isBusy,
      isLoading: isLoading ?? this.isLoading,
      apartments: apartments ?? _apartments,
    );
  }
}
