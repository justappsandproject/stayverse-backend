import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/data/enum/enums.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/date_time_service.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';
import 'package:stayverse/feature/wallet/model/data/transaction_history_response.dart';
import 'package:stayverse/shared/app_icons.dart';

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
      decoration: BoxDecoration(
        color: $styles.colors.greyF7,
        border: Border(
          bottom: BorderSide(
            color: $styles.colors.greyD9,
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
                    color: context.color.primary.withOpacity(0.2),
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
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: $styles.colors.black,
                        ),
                        maxLines: 2,
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
                              color: Colors.grey,
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
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
