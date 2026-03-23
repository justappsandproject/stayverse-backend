import 'package:fixed_collections/fixed_collections.dart';

class CarDetailsUiState {
  final bool isBusy;
  final bool? isFavourite;
  final bool isFavouriteBusy ;
    final List<DateTime>? _bookedDays;
  FixedList<DateTime> get bookedDays => FixedList<DateTime>(_bookedDays ?? []);


  const CarDetailsUiState({
    this.isBusy = false,
    this.isFavouriteBusy = false,
    this.isFavourite,
    List<DateTime>? bookedDays,
  }) : _bookedDays = bookedDays;

  CarDetailsUiState copyWith({
    bool? isBusy,
    bool? isFavourite,
    bool? isFavouriteBusy
    , List<DateTime>? bookedDays,
  }) {
    return CarDetailsUiState(
      isBusy: isBusy ?? this.isBusy,
      isFavouriteBusy: isFavouriteBusy ?? this.isFavouriteBusy,
      isFavourite: isFavourite ?? this.isFavourite,
      bookedDays: bookedDays ?? _bookedDays,
    );
  }
}
