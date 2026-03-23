// import 'package:stayverse/core/commonLibs/common_libs.dart';
// import 'package:stayverse/feature/home/view/component/cards/apartments_card.dart';

// class NewlyListedItem extends StatelessWidget {
//   const NewlyListedItem({super.key, required this.listedItem});

//   final List<Map<String, String>> listedItem;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 270,
//       child: ListView.builder(
//         padding: EdgeInsets.zero,
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemCount: listedItem.length,
//         itemBuilder: (context, index) {
//           final property = listedItem[index];
//           return Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: ApartmentPropertyCard(
//               imageUrl: property['imageUrl']!,
//               title: property['title']!,
//               location: property['location']!,
//               price: property['price']!,
//               period: property['period']!,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
