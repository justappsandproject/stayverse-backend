import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/date_time_service.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/feature/messaging/model/data/proposal.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as stream;

class ChefProposalCard extends StatelessWidget {
  final Proposal data;
  final stream.Message message;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final bool isBusy;
  final String? currentProposalId;

  const ChefProposalCard({
    super.key,
    required this.data,
    required this.message,
    this.onAccept,
    this.onReject,
    this.isBusy = false,
    this.currentProposalId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: FractionallySizedBox(
        widthFactor: 0.78,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.color.inverseSurface.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Proposal',
                          style: $styles.text.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: context.color.inverseSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _getStatusColor(data.status).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            data.status?.value ?? 'Pending',
                            style: $styles.text.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 10.5,
                              color: _getStatusColor(data.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Text(
                      data.description ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: $styles.text.bodySmall.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: context.color.inverseSurface.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                    const Gap(14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: context.color.inverseSurface
                                    .withOpacity(0.06),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_outlined,
                                color: context.color.inverseSurface,
                                size: 18,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              MoneyServiceV2.formatNaira(
                                data.price ?? 0,
                                decimalDigits: 0,
                              ),
                              style: $styles.text.bodySmall.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: context.color.inverseSurface,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Ends at ${DateTimeService.format(data.proposalEndDate)}',
                          style: $styles.text.bodySmall.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color:
                                context.color.inverseSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (data.status == ProposalStatus.pending) ...[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: context.color.inverseSurface.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: (isBusy && data.id == currentProposalId)
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: context.color.inverseSurface,
                            strokeWidth: 2,
                          ),
                        ).alignAtBottomRight()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppBtn.basic(
                              onPressed: onReject,
                              semanticLabel: 'Reject proposal',
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: context.color.inverseSurface
                                        .withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'Reject',
                                  style: $styles.text.bodySmall.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: context.color.inverseSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            AppBtn.basic(
                              onPressed: onAccept,
                              semanticLabel: 'Accept proposal',
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: context.color.inverseSurface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Accept',
                                  style: $styles.text.bodySmall.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ProposalStatus? status) {
    if (status == null) return const Color(0xFFF59E0B);

    switch (status) {
      case ProposalStatus.pending:
        return const Color(0xFFF59E0B);
      case ProposalStatus.accepted:
        return const Color(0xFF10B981);
      case ProposalStatus.rejected:
        return const Color(0xFFEF4444);
    }
  }
}
