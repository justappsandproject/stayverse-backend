import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/feature/favourite/view/component/section_title.dart';
import 'package:stayverse/feature/home/model/data/chef_response.dart';
import 'package:stayverse/shared/line.dart';

class ChefAboutSection extends StatelessWidget {
  final Chef? chef;
  const ChefAboutSection({
    super.key,
    this.chef,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'About'),
        const Gap(8),
        Text(
          '${chef?.about}',
          style: $styles.text.body.copyWith(
            fontSize: 14,
            height: 1.3,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
        const Gap(12),
        const HorizontalLine(),
        const Gap(12),
      ],
    );
  }
}
