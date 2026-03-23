import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({
    super.key,
  });

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool _isSelected = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Switch.adaptive(
        value: _isSelected,
        trackOutlineWidth: const WidgetStatePropertyAll(0),
        onChanged: (value) {
          setState(() {
            _isSelected = value;
          });
        },
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white;
            }
            if (states.contains(WidgetState.selected)) {
              return context.color.primary;
            }
            return Colors.white;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.grey.shade100;
            }
            if (states.contains(WidgetState.selected)) {
              return context.color.primary.withValues(alpha: 0.3);
            }
            return Colors.grey.shade300;
          },
        ),
      ),
    );
  }
}
