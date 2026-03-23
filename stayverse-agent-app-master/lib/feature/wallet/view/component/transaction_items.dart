import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/data/enum/enums.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/date_time_service.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/feature/wallet/model/data/transaction_history_response.dart';
import 'package:stayvers_agent/shared/app_icons.dart';

class TransactionItems extends StatelessWidget {
  final Transactions transaction;

  const TransactionItems({
    super.key,
    required this.transaction,
  });

  AppIcons _getTransactionIcon() {
    if (transaction.type == TransactionType.credit) {
      return AppIcons.bank_recieve;
    } else {
      return AppIcons.bank_send;
    }
  }

  String _getTransactionTitle() {
    if (transaction.description?.isNotEmpty == true) {
      return transaction.description!;
    }

    if (transaction.type == TransactionType.credit) {
      return 'Money Received';
    } else {
      return 'Money Sent';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.greyF7,
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyD9,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.yellowD7.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: AppIcon(
                    _getTransactionIcon(),
                    size: 20,
                    color: context.themeColors.primaryAccent,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTransactionTitle(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black0C,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            DateTimeService.format(transaction.createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey81,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: transaction.status?.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              transaction.status?.displayName ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: transaction.status?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.type == TransactionType.credit ? '+' : '-'}${MoneyServiceV2.formatNaira(transaction.amount)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.black0C,
            ),
          ),
        ],
      ),
    );
  }
}
