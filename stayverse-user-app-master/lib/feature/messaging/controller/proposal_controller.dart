import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/feature/dashboard/model/dataSource/dashboard_network_service.dart';
import 'package:stayverse/feature/messaging/view/ui_state/proposal_ui_state.dart';

class CreateProposalController extends StateNotifier<ProposalUiState>
    with CheckForServerError {
  final DashNetworkService _dashNetworkService;

  CreateProposalController(this._dashNetworkService)
      : super(ProposalUiState(isBusy: false));

  Future<ProposalStatus?> responseProposal(
      String id, bool acceptOrReject) async {
    if (state.isBusy == true) {
      BrimToast.showError('Please wait for the previous request to complete');
      return null;
    }
    _isBusy(true);
    _currentProposalId(id);

    try {
      ServerResponse? serverResponse = await _dashNetworkService.proposalAction(
          proposalId: id, status: acceptOrReject);
      if (errorOccured(serverResponse)) return null;

      BrimToast.showSuccess(
          'Proposal ${acceptOrReject ? 'accepted' : 'rejected'} successfully');

      return acceptOrReject ? ProposalStatus.accepted : ProposalStatus.rejected;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return null;
    } finally {
      reset();
      state = state.resetCurrentProposalId();
    }
  }

  void _currentProposalId(String id) {
    state = state.copyWith(currentProposalId: id);
  }

  void _isBusy(bool isBusy) {
    state = state.copyWith(isBusy: isBusy);
  }

  void reset() {
    _isBusy(false);
  }
}

final proposalController =
    StateNotifierProvider<CreateProposalController, ProposalUiState>((ref) {
  return CreateProposalController(locator.get());
});
