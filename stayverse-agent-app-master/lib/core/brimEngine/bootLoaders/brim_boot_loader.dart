abstract class BrimBootLoader {
  Future<void> boot() async {}
  Future<void> afterBoot() async {}
}

Future<void> bootApplication(Map<Type, BrimBootLoader> providers) async {
  for (var provider in providers.values) {
    await provider.boot();
  }
  return;
}

Future<void> bootFinished(
  Map<Type, BrimBootLoader> providers,
) async {
  for (var provider in providers.values) {
    await provider.afterBoot();
  }
}
