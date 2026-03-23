import 'package:fixed_collections/fixed_collections.dart';

class ChefDetailsUistate {
  const ChefDetailsUistate({
    this.isBusy = false,
    this.isFavouriteBusy = false,
    this.isFavourite,
    List<DateTime>? bookedDays,
  }) : _bookedDays = bookedDays;
  final List<DateTime>? _bookedDays;
  FixedList<DateTime> get bookedDays => FixedList<DateTime>(_bookedDays ?? []);

  final bool isBusy;
  final bool? isFavourite;
  final bool isFavouriteBusy;

  ChefDetailsUistate copyWith({
    bool? isBusy,
    bool? isFavourite,
    bool? isFavouriteBusy,
    List<DateTime>? bookedDays,
  }) {
    return ChefDetailsUistate(
      bookedDays: bookedDays ?? _bookedDays,
      isBusy: isBusy ?? this.isBusy,
      isFavouriteBusy: isFavouriteBusy ?? this.isFavouriteBusy,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
