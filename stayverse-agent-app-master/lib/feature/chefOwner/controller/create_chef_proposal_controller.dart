import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/proposal_response.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_proposal_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/dataSoruce/network/chef_profile_network_service.dart';
import 'package:stayvers_agent/feature/chefOwner/view/ui_state/create_chef_proposal_ui_state.dart';

class CreateChefController extends StateNotifier<CreateProposalUiState>
    with CheckForServerError {
  final ChefNetworkService _chefNetworkService;

  CreateChefController(this._chefNetworkService)
      : super(CreateProposalUiState(isBusy: false));

  Future<Proposal?> createChefProposal(
      String id, ChefProposalRequest request) async {
    _isBusy(true);
    try {
      ServerResponse? serverResponse =
          await _chefNetworkService.createChefProposal(id, request);
      if (errorOccured(serverResponse)) return null;

      BrimToast.showSuccess('Chef proposal created successfully');

      final proposal =
          ProposalResponse.fromJson(serverResponse?.payload as DynamicMap);
      return proposal.data?.proposal;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return null;
    } finally {
      reset();
    }
  }

  void _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  void reset() {
    _isBusy(false);
  }
}

final proposalController =
    StateNotifierProvider<CreateChefController, CreateProposalUiState>((ref) {
  return CreateChefController(locator.get());
});
