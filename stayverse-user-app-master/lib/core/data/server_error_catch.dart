import 'package:stayverse/core/data/server_respond.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/core/util/app/helper.dart';

mixin CheckForServerError {
  bool errorOccured(ServerResponse? serverResponse,
      {String? errorMessage, String? otherMessage, bool showToast = true}) {
    if (isObjectEmpty(serverResponse)) {
      if (showToast) {
        BrimToast.showError(errorMessage ?? 'Please Try Again');
      }
      return true;
    }
    if (!(serverResponse!.isSuccess)) {
      if (showToast) {
        BrimToast.showError(otherMessage ??
            serverResponse.defaultMessage ??
            'Please Try Again');
      }
      return true;
    }
    return false;
  }
}

bool errorOccured(ServerResponse? serverResponse,
    {String? errorMessage, String? otherMessage, bool showToast = true}) {
  if (isObjectEmpty(serverResponse)) {
    if (showToast) {
      BrimToast.showError(errorMessage ?? 'Please Try Again');
    }
    return true;
  }
  if (!(serverResponse!.isSuccess)) {
    if (showToast) {
      BrimToast.showError(
          otherMessage ?? serverResponse.defaultMessage ?? 'Please Try Again');
    }
    return true;
  }
  return false;
}