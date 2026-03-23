import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/auth/model/data/login_request.dart';
import 'package:stayvers_agent/auth/model/data/login_response.dart';
import 'package:stayvers_agent/auth/model/dataSource/network/auth_network_service.dart';
import 'package:stayvers_agent/auth/view/uistate/login_ui_state.dart';
import 'package:stayvers_agent/core/config/dependecies.dart';
import 'package:stayvers_agent/core/config/evn/env.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/data/server_error_catch.dart';
import 'package:stayvers_agent/core/data/typedefs.dart';
import 'package:stayvers_agent/core/event/brim_resgister.dart';
import 'package:stayvers_agent/core/event/evenList/route_history_event.dart';
import 'package:stayvers_agent/core/exception/app_exceptions.dart';
import 'package:stayvers_agent/core/service/brimAuth/brim_auth.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/feature/dashboard/view/page/dashboard_page.dart';

class LoginController extends StateNotifier<LoginUiState>
    with CheckForServerError {
  LoginController(this._authNetworkService)
      : super(LoginUiState(isBusy: false));

  final AuthNetworkService _authNetworkService;

  Future<LoginRoute> login(LoginRequest request) async {
    _isBusy(true);
    try {
      final serverResposne = await _authNetworkService.login(request);

      if (errorOccured(serverResposne)) {
        return LoginRoute.failed;
      }

      final data = LoginResponse.fromJson(serverResposne?.data as DynamicMap);

      if (data.isEmailVerified != true ||
          data.user?['isEmailVerified'] != true) {
        BrimToast.showSuccess('Please verify your email');
        return LoginRoute.emailNotVerified;
      }
      await eventOn<RouteHistoryEvent>(
          params: {Env.screenStorageScreen: DashBoardPage.route});
      await BrimAuth.login(data.user,
          token: data.accessToken,
          customTokens: {Env.chatToken: data.chatToken ?? ''});

      return LoginRoute.success;
    } on BrimAppException catch (e) {
      BrimToast.showError(e.toString());
      return LoginRoute.failed;
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

final loginController =
    StateNotifierProvider<LoginController, LoginUiState>((ref) {
  return LoginController(locator.get());
});
