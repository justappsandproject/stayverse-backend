import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/server_respond.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/feature/discover/model/data/overview_response.dart';
import 'package:stayvers_agent/feature/discover/model/dataSource/network/discover_network_service.dart';
import 'package:stayvers_agent/feature/discover/view/ui_state/overview_ui_state.dart';



class OverviewController extends StateNotifier<OverviewUiState>
    with CheckForServerError {
  OverviewController(this._discoverNetworkService)
      : super(OverviewUiState(isLoading: false));

  final DiscoverNetworkService _discoverNetworkService;

 Future<void> getOverviewMetrics() async {
    try {
      _setLoading(true);
      ServerResponse? response = await _discoverNetworkService.getOverviewMetrics();
      
      if (errorOccured(response, showToast: false)) return;
      
      final responseData = response!.data as DynamicMap;
      final overview = OverviewData.fromJson(responseData);
      _updateOverviewData(overview);
    } catch (_) {
    } finally {
      reset();
    }
  }

  void _updateOverviewData(OverviewData? overviewData) {
    if (overviewData == null) return;
    state = state.copyWith(data: overviewData);
  }

 void _setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void reset() {
    _setLoading(false);
  }
}

final overviewController =
    StateNotifierProvider<OverviewController, OverviewUiState>((ref) {
  return OverviewController(locator.get());
});
