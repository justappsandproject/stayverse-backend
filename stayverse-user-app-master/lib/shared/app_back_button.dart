import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/shared/buttons.dart';

class AppBackButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onBack;

  const AppBackButton({
    super.key,
    this.icon,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = $navigate.canPop();

    if (!canGoBack) return const SizedBox.shrink();

    return AppBtn.basic(
      onPressed: onBack ?? () => $navigate.back(),
      semanticLabel: 'back button',
      child: Icon(
        icon ?? Icons.arrow_back_rounded,
        color: Colors.black,
      ),
    );
  }
}
