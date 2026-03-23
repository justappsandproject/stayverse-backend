import 'package:dart_extensions/dart_extensions.dart' hide Message;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/core/service/toast_service.dart';
import 'package:stayverse/feature/dashboard/controller/dashboard_controller.dart';
import 'package:stayverse/feature/messaging/controller/proposal_controller.dart';
import 'package:stayverse/feature/messaging/model/data/proposal.dart';
import 'package:stayverse/feature/messaging/view/component/chat_error_screen.dart';
import 'package:stayverse/feature/messaging/view/component/chat_preload.dart';
import 'package:stayverse/feature/messaging/view/component/chef_proposal_card.dart';
import 'package:stayverse/feature/wallet/controller/wallet_controller.dart';
import 'package:stayverse/feature/wallet/view/page/paystack_page.dart';
import 'package:stayverse/shared/app_icons.dart';
import 'package:stayverse/shared/cutomizeLoading/customized_loading_overlay.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/skeleton.dart';
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

  void sendProposal() {
    widget.channel.sendMessage(Message(
      type: 'proposal',
    ));
  }
}

class ChatItem extends ConsumerWidget {
  final Channel channel;

  const ChatItem({super.key, required this.channel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        actions: const [
          // AppBtn.basic(
          //   onPressed: () {},
          //   semanticLabel: '',
          //   child: Container(
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //     ),
          //     child: const AppIcon(
          //       AppIcons.hori_more,
          //     ),
          //   ),
          // ),
          Gap(20),
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
                    isBusy: ref.watch(proposalController).isBusy ?? false,
                    currentProposalId:
                        ref.watch(proposalController).currentProposalId,
                    message: messageDetails.message,
                    onAccept: () => _responseProposal(
                        context,
                        ref,
                        _getProposal(messageDetails.message),
                        true,
                        messageDetails.message),
                    onReject: () => _responseProposal(
                        context,
                        ref,
                        _getProposal(messageDetails.message),
                        false,
                        messageDetails.message),
                  );
                }
                return builder;
              },
            ),
          ),
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

  void _responseProposal(BuildContext context, WidgetRef ref, Proposal proposal,
      bool acceptOrReject, Message message) async {
    final balance = ref.read(dashboadController).user?.balance;
    if (acceptOrReject == true) {
      if (!MoneyServiceV2.isBalanceEnough(
          balance: balance!, amount: proposal.price ?? 0)) {
        final amountRequired = (proposal.price ?? 0) - balance;
        _processPayment(
            context: context,
            fundAmount: amountRequired,
            proposal: proposal,
            ref: ref,
            message: message,
            acceptOrReject: acceptOrReject);
        return;
      }
    }
    _processProposal(
        ref: ref,
        proposal: proposal,
        acceptOrReject: acceptOrReject,
        message: message);
  }

  void _processPayment(
      {required BuildContext context,
      required double fundAmount,
      required Proposal proposal,
      required WidgetRef ref,
      required Message message,
      required bool acceptOrReject}) async {
    CustomizedLoadingOverlay.show(
        context: context, message: 'Processing payment...');

    final response =
        await ref.read(walletController.notifier).fundWallet(fundAmount);

    if (response?.data?.authorizationUrl == null) {
      BrimToast.showError('Please try payment again');
      CustomizedLoadingOverlay.hide();
      return;
    }
    CustomizedLoadingOverlay.hide();

    final result = await $navigate.toWithParameters(PayStackPage.route,
        args: response?.data?.authorizationUrl ?? '');

    if (result == true) {
      if (context.mounted) {
        CustomizedLoadingOverlay.show(
            context: context, message: 'Verifying payment...');
      }
      await ref
          .read(walletController.notifier)
          .verifyPayment(response?.data?.reference ?? '');

      await Future.wait([
        ref.read(dashboadController.notifier).refreshUser(),
        ref.read(walletController.notifier).getTransactionHistory(),
      ]);
      CustomizedLoadingOverlay.hide();

      _processProposal(
          ref: ref,
          proposal: proposal,
          acceptOrReject: acceptOrReject,
          message: message);
    }
  }

  void _processProposal(
      {required WidgetRef ref,
      required Proposal proposal,
      required bool acceptOrReject,
      required Message message}) async {
    final response = await ref
        .read(proposalController.notifier)
        .responseProposal(proposal.id ?? '', acceptOrReject);

    if (response != null) {
      channel.sendMessage(Message(
        text: 'Proposal: ${acceptOrReject ? 'Accepted' : 'Rejected'}',
        extraData: {
          'extraDataType': ExtraDataType.proposalAction.id,
          'status': response.id,
        },
        quotedMessageId: message.id,
        threadParticipants: message.threadParticipants,
      ));

      channel.sendReaction(message, response.id, extraData: {
        'extraDataType': ExtraDataType.proposalAction.id,
        'status': response.id,
      });
    }
  }
}
