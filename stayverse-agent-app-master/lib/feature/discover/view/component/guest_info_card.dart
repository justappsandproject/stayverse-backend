import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/brimAuth/brim_auth.dart';
import 'package:stayvers_agent/core/service/streamChat/communication.dart';
import 'package:stayvers_agent/core/util/app/helper.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/discover/model/data/booking_response.dart';
import 'package:stayvers_agent/feature/messaging/view/chats.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';

class GuestInfoCard extends StatelessWidget {
  final BookingUser user;

  const GuestInfoCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final fullName = user.firstname!.isNotEmpty && user.lastname!.isNotEmpty
        ? '${user.firstname} ${user.lastname}'
        : 'No Name';
    final email = user.email ?? 'Email not available';
    final imageTxt =
        user.firstname!.isNotEmpty ? user.firstname![0].toUpperCase() : 'U';

    final imageUrl = user.profilePicture ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              // Avatar Circle
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Center(
                  child: isEmpty(imageUrl)
                      ? Text(
                          imageTxt,
                          style: $styles.text.title1.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            imageUrl,
                          ),
                        ),
                ),
              ),
              const Gap(10),

              // Guest name & email
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: $styles.text.body.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: $styles.text.body.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Action Buttons
          Row(
            children: [
              AppBtn(
                semanticLabel: 'Chat with user',
                onPressed: () => _chatUser(),
                circular: true,
                padding: const EdgeInsets.all(10),
                bgColor: context.themeColors.primaryAccent,
                child: const AppIcon(
                  AppIcons.message,
                  color: Colors.black,
                ),
              ),
              const Gap(10),
              AppBtn(
                semanticLabel: 'Call user',
                onPressed: () => _callUser(user.phoneNumber ?? ''),
                circular: true,
                padding: const EdgeInsets.all(10),
                bgColor: context.themeColors.primaryAccent,
                child: const AppIcon(AppIcons.call),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _chatUser() {
    final channel = CommnunicationSevice.instance.chatUser(
      myId: BrimAuth.curentUser()?.agent?.id ?? '',
      guestId: user.id ?? '',
    );

    if (channel != null) {
      $navigate.toWithParameters(Chats.route, args: channel);
    }
  }

  void _callUser(String number) {
    openPhoneNumber(number: number);
  }
}
