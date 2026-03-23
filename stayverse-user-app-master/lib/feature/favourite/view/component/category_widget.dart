import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/shared/app_icons.dart';

class CategoryItemWidget extends StatelessWidget {
  final AppIcons icon;
  final String label;
  final bool isSelected;

  const CategoryItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: isSelected
                  ? context.color.primary.withOpacity(0.25)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? context.color.primary.withOpacity(0.5)
                    : Colors.grey.shade200,
              )),
          child: Column(
            children: [
              AppIcon(
                icon,
                size: 26,
                color:
                    isSelected ? context.color.primary : Colors.grey.shade400,
              ),
              const Gap(3),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color:
                      isSelected ? context.color.primary : Colors.grey.shade400,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
