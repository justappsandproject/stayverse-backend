// import 'package:dart_extensions/dart_extensions.dart';
// import 'package:stayverse/core/commonLibs/common_libs.dart';
// import 'package:stayverse/shared/app_icons.dart';

// class MessageTile extends StatelessWidget {
//   final String message;
//   final bool sendByMe;

//   const MessageTile({super.key, required this.message, required this.sendByMe});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment:
//             sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding:
//                 const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
//             decoration: BoxDecoration(
//               color:
//                   sendByMe ? const Color(0xffFFEAD1) : const Color(0xff780000),
//               borderRadius: sendByMe
//                   ? const BorderRadius.only(
//                       topLeft: Radius.circular(23),
//                       topRight: Radius.circular(23),
//                       bottomLeft: Radius.circular(23))
//                   : const BorderRadius.only(
//                       topLeft: Radius.circular(23),
//                       topRight: Radius.circular(23),
//                       bottomRight: Radius.circular(23)),
//             ),
//             child: Text(message,
//                 textAlign: TextAlign.start,
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 10,
//                 style: $styles.text.bodySmall.copyWith(
//                     fontWeight: FontWeight.w400,
//                     color: sendByMe
//                         ? $styles.colors.greyStrong
//                         : $styles.colors.white,
//                     fontSize: 16.sp)),
//           ),
//           const Gap(3),
//           Row(
//             mainAxisAlignment:
//                 sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text('12:45 pm',
//                   style: $styles.text.bodySmall.copyWith(
//                       fontWeight: FontWeight.w400,
//                       color: $styles.colors.greyMedium,
//                       fontSize: 16.sp)),
//               Visibility(
//                       visible: sendByMe,
//                       child: const AppIcon(AppIcons.checkmark))
//                   .paddingOnly(left: 5)
//             ],
//           )
//         ],
//       ).paddingOnly(
//         top: 10,
//         bottom: 10,
//       ),
//     );
//   }
// }
