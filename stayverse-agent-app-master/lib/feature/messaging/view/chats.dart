import 'package:dart_extensions/dart_extensions.dart' hide Message;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/brimAuth/brim_auth.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/carOwner/model/data/proposal_response.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/create_chef_proposal_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_proposal_request.dart';
import 'package:stayvers_agent/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayvers_agent/feature/messaging/view/component/chat_error_screen.dart';
import 'package:stayvers_agent/feature/messaging/view/component/chat_preload.dart';
import 'package:stayvers_agent/feature/messaging/view/component/chef_proposal_card.dart';
import 'package:stayvers_agent/feature/messaging/view/component/create_proposal.dart';
import 'package:stayvers_agent/shared/app_icons.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/empty_state_view.dart';
import 'package:stayvers_agent/shared/skeleton.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Chats extends ConsumerStatefulWidget {
  static const String route = '/Chats';

  final Channel channel;

  const Chats({super.key, required this.channel});

  @override
  ConsumerState<Chats> createState() => _ChatsState();
}

class _ChatsState extends ConsumerState<Chats> {
  @override
  void initState() {
    super.initState();

    widget.channel.watch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 1.sh,
      child: Stack(
        children: [
          StreamChannel(
            channel: widget.channel,
            child: FutureBuilder<bool>(
              future: widget.channel.initialized,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  final error = snapshot.error!;
                  return ChatErrorScreen(
                    error: error.toString(),
                  );
                }
                if (snapshot.connectionState != ConnectionState.done) {
                  return ChatPreLoad(
                    channel: widget.channel,
                  );
                }
                return ChatItem(
                  channel: widget.channel,
                );
              },
            ),
            errorBuilder: (context, error, stackTrace) {
              return ChatErrorScreen(
                error: error.toString(),
              );
            },
            loadingBuilder: (context) => ChatPreLoad(
              channel: widget.channel,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatItem extends ConsumerWidget {
  final Channel channel;

  const ChatItem({super.key, required this.channel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceType = ref.watch(
      dashboadController.select((state) => state.user?.agent?.serviceType),
    );

    return BrimSkeleton(
      bodyPadding: EdgeInsets.zero,
      isAuthSkeleton: true,
      appBar: StreamChannelHeader(
        elevation: 0,
        backgroundColor: context.color.surface,
        subtitle: const SizedBox.shrink(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFF3F4F6),
            height: 1,
          ),
        ),
        onTitleTap: () {},
        title: Row(
          children: [
            StreamChannelAvatar(channel: channel),
            const Gap(10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  StreamChannelName(
                    channel: channel,
                    textStyle: $styles.text.bodySmall.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: context.color.inverseSurface,
                    ),
                  ),
                  StreamChannelInfo(
                    showTypingIndicator: true,
                    channel: channel,
                    textStyle: $styles.text.bodySmall.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: context.color.inverseSurface,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          AppBtn.basic(
            onPressed: () {},
            semanticLabel: '',
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const AppIcon(
                AppIcons.hori_more,
              ),
            ),
          ),
          const Gap(20),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              emptyBuilder: (_) => const EmptyStateView(),
              errorBuilder: (_, __) => const EmptyStateView(),
              messageBuilder: (context, messageDetails, messageList, builder) {
                final extraData = messageDetails.message.extraData;
                if (extraData['extraDataType'] == ExtraDataType.proposal.id) {
                  return ChefProposalCard(
                    data: _getProposal(messageDetails.message),
                    message: messageDetails.message,
                  );
                }

                return builder;
              },
            ),
          ),
          if (serviceType == ServiceType.chef) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: ref.watch(proposalController
                      .select((state) => state.isBusy ?? false))
                  ? const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: AppColors.black,
                        strokeWidth: 2,
                      ),
                    )
                  : AppBtn.from(
                      text: 'Create Proposal',
                      expand: true,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                      bgColor: AppColors.black,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ChefProposalDialog(
                            onSubmit: (title, price, completionDateTime) async {
                              final userId = otherMemberId();
                              if (userId == null) {
                                BrimToast.showError(
                                    'Please Load the chat and try again');
                                return;
                              }
                              final proposal = await ref
                                  .read(proposalController.notifier)
                                  .createChefProposal(
                                    userId,
                                    ChefProposalRequest(
                                      description: title,
                                      price: price,
                                      date: completionDateTime,
                                    ),
                                  );

                              if (proposal != null) {
                                sendCustomProposalMessage(proposal);
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
            const Gap(10),
          ],
          StreamMessageInput(
            sendButtonLocation: SendButtonLocation.inside,
            onMessageSent: (message) {},
            idleSendButton: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ColoredBox(
                color: $styles.colors.greyMedium,
                child: const AppIcon(
                  AppIcons.send,
                  size: 22,
                ).paddingAll(4),
              ),
            ).paddingAll(4),
            activeSendButton: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ColoredBox(
                color: context.themeColors.primaryAccent,
                child: const AppIcon(
                  AppIcons.send,
                  size: 22,
                ).paddingAll(4),
              ),
            ).paddingAll(4),
          ),
        ],
      ),
      isBusy: false,
    );
  }

  Proposal _getProposal(Message message) {
    var proposal = Proposal.fromJson(message.extraData);
    final latestReactions = message.latestReactions;
    if (latestReactions != null) {
      final reaction = latestReactions.firstOrNullWhere(
        (element) =>
            element.extraData['extraDataType'] ==
            ExtraDataType.proposalAction.id,
      );
      if (reaction != null) {
        final status = ProposalStatus.fromString(
          reaction.extraData['status'].toString(),
        );
        if (status != proposal.status) {
          proposal = proposal.copyWith(status: status);
        }
      }
    }
    return proposal;
  }

  void sendCustomProposalMessage(Proposal proposal) async {
    final message = Message(
      text:
          'New proposal sent: Description: ${proposal.description} Price: ${MoneyServiceV2.formatMoney(proposal.price?.toDouble() ?? 0)}',
      extraData: proposal.toJson(),
    );

    await channel.sendMessage(message);
  }

  String? otherMemberId() {
    final members = channel.state?.members;
    final myUserId = BrimAuth.curentUser()?.id ?? '';
    final otherMember =
        members?.where((element) => element.userId != myUserId).firstOrNull;
    if (otherMember == null) {
      return null;
    }
    return otherMember.userId;
  }
}
