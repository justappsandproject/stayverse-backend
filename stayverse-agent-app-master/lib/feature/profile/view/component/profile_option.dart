import 'package:stayvers_agent/core/commonLibs/common_libs.dart';

class ProfileOption extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ProfileOption({
    super.key,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: $styles.text.bodyBold.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
