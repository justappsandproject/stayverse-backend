import 'package:stayvers_agent/core/config/dependecies.dart';

class NavigationService {
  /// Navigates to a named route
  Future<dynamic>? to(String routeName) {
    return $appKey.currentState?.pushNamed(routeName);
  }

  /// Navigates to a named route with arguments
  Future<dynamic>? toWithParameters(String routeName, {required Object args}) {
    return $appKey.currentState?.pushNamed(routeName, arguments: args);
  }

  /// Replaces the current route with a new route
  Future<dynamic>? replace(String routeName) {
    return $appKey.currentState?.pushReplacementNamed(routeName);
  }

  /// Pops the navigation stack until the given depth
  void popUntil(int length) {
    int count = 0;
    $appKey.currentState?.popUntil((_) => count++ >= length);
  }

  /// Replaces the current route with a new route and passes arguments
  Future<dynamic>? replaceWithParameters(String routeName,
      {required Object args}) {
    return $appKey.currentState
        ?.pushReplacementNamed(routeName, arguments: args);
  }

  /// Checks if there is any route to pop
  bool canPop() {
    return $appKey.currentState?.canPop() ?? false;
  }

  /// Pops the current route if possible
  void back() {
    if (canPop()) {
      $appKey.currentState?.pop();
    }
  }

  /// Pops the current route with a result
  void backWithParameters({required Object args}) {
    $appKey.currentState?.pop(args);
  }

  /// Clears the entire navigation stack and navigates to the given route
  Future<dynamic>? clearAllTo(String routeName, {String? predicate}) {
    return $appKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => predicate == null ? false : route.settings.name == predicate,
    );
  }

  /// Clears the entire navigation stack, navigates to the route, and passes arguments
  Future<dynamic>? clearAllToWithParameters(String routeName,
      {required Object args, String? predicate}) {
    return $appKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => predicate == null ? false : route.settings.name == predicate,
      arguments: args,
    );
  }
}
