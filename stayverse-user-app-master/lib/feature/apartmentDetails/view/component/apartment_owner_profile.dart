import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/brimAuth/brim_auth.dart';
import 'package:stayverse/core/service/streamChat/communication.dart';
import 'package:stayverse/core/util/app/helper.dart';
import 'package:stayverse/feature/home/model/data/apartment_response.dart';
import 'package:stayverse/feature/messaging/view/chats.dart';
import 'package:stayverse/shared/app_icons.dart';
import 'package:stayverse/shared/buttons.dart';

class ApartmentOwnerProfile extends StatelessWidget {
  final Agent? agent;
  const ApartmentOwnerProfile({super.key, this.agent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apartment Owner',
          style: $styles.text.title2.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: isEmpty(agent?.user?.profilePicture)
                        ? Text(
                            agent?.user?.firstname?.isNotEmpty == true
                                ? agent!.user!.firstname![0].toUpperCase()
                                : 'U',
                            style: $styles.text.title1.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              agent?.user?.profilePicture ?? '',
                            )),
                  ),
                ),
                const Gap(10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${agent?.user?.firstname ?? 'No'} ${agent?.user?.lastname ?? 'Name'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: $styles.text.body.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        agent?.user?.email ?? 'Email not available',
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
            Row(
              children: [
                AppBtn(
                  semanticLabel: 'Chat with agent',
                  onPressed: () {
                    _chatAgent();
                  },
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
                  semanticLabel: 'Call with agent',
                  onPressed: () {
                    openPhoneNumber(number: agent?.user?.phoneNumber ?? '');
                  },
                  circular: true,
                  padding: const EdgeInsets.all(10),
                  bgColor: context.themeColors.primaryAccent,
                  child: const AppIcon(AppIcons.call),
                )
              ],
            ),
          ],
        ),
        const Gap(20),
      ],
    );
  }

  void _chatAgent() {
    final channel = CommnunicationSevice.instance.chatAgent(
      myId: BrimAuth.curentUser()?.id ?? '',
      agentId: agent?.id ?? '',
    );

    if (channel != null) {
      $navigate.toWithParameters(Chats.route, args: channel);
    }
  }
}
