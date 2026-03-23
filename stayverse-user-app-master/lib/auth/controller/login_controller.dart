import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/auth/model/data/login_request.dart';
import 'package:stayverse/auth/model/data/login_response.dart';
import 'package:stayverse/auth/model/dataSource/network/auth_network_service.dart';
import 'package:stayverse/auth/view/uistate/login_ui_state.dart';
import 'package:stayverse/core/config/dependecies.dart';
import 'package:stayverse/core/config/evn/env.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/data/server_error_catch.dart';
import 'package:stayverse/core/data/typedefs.dart';
import 'package:stayverse/core/event/brim_resgister.dart';
import 'package:stayverse/core/event/evenList/route_history_event.dart';
import 'package:stayverse/core/exception/app_exceptions.dart';
import 'package:stayverse/core/service/brimAuth/brim_auth.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/feature/dashboard/view/page/dashboard_page.dart';

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

      if (data.isEmailVerified != true) {
        BrimToast.showSuccess('Please verify your email');
        return LoginRoute.emailNotVerified;
      }
      await eventOn<RouteHistoryEvent>(
          params: {Env.screenStorageScreen: DashbBoardScreenPage.route});

      await BrimAuth.login(data.user?.toJson(),
          token: data.accessToken,
          customTokens: {
            Env.chatToken: data.chatToken ?? '',
          });

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
