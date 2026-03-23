import 'package:stayvers_agent/feature/chefOwner/model/data/chef_details_response.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_response.dart';

class ChefProfileUiState {
  final bool? isBusy;
  final ChefProfileData? profile;
  final ChefDetailsData? status;

  ChefProfileUiState({
    this.isBusy = false,
    this.profile,
    this.status,
  });

  ChefProfileUiState copyWith({
    bool? isBusy,
    ChefProfileData? profile,
    ChefDetailsData? status,
  }) {
    return ChefProfileUiState(
      isBusy: isBusy ?? this.isBusy,
      profile: profile ?? this.profile,
      status: status ?? this.status,
    );
  }
}
