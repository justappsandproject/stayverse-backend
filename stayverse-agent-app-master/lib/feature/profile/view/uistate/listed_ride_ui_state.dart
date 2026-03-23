import 'package:fixed_collections/fixed_collections.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/ride_response.dart';

class ListedRideUiState {
  const ListedRideUiState({
    this.isBusy = false,
    this.isLoading= false,
    List<Ride>? rides,

  })  : _rides = rides;

 final bool isBusy;

  // Loading state

  final bool isLoading;

    // listed data

  final List<Ride>? _rides;

  FixedList<Ride> get rides => FixedList(_rides ?? []);

  ListedRideUiState copyWith({
    bool? isBusy,
    bool? isLoading,
    List<Ride>? rides,
  }) {
    return ListedRideUiState(
       isBusy: isBusy ?? this.isBusy,
      isLoading: isLoading ?? this.isLoading,
      rides: rides ?? _rides,
    );
  }
}
