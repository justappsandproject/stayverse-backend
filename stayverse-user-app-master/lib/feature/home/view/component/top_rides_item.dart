import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/util/image/app_assets.dart';

class TopVehicles extends StatelessWidget {
  const TopVehicles(
      {super.key, required this.vehicles, required this.itemName});

  final List<String> vehicles;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          itemName,
          style: $styles.text.bodySmall.copyWith(
            fontSize: 18,
            height: 1,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                vehicles.map((value) => TopRidesItem(name: value)).toList(),
          ),
        ),
      ],
    );
  }
}

class TopRidesItem extends StatelessWidget {
  final String name;

  const TopRidesItem({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: context.color.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              AppAsset.car,
              height: 35,
              width: 35,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(8),
          Text(
            name,
            style: $styles.text.bodySmall.copyWith(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
