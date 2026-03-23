import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/extension/extension.dart';
import 'package:stayverse/core/service/date_time_service.dart';
import 'package:stayverse/core/service/financial/money_service_v2.dart';

class TransferBreakDown extends StatelessWidget {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? address;
  final String? hostName;
  final double? totalPrice;

  const TransferBreakDown({
    super.key,
    this.checkInDate,
    this.checkOutDate,
    this.checkInTime,
    this.checkOutTime,
    this.address,
    this.hostName,
    this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.color.primary),
      ),
      child: Column(
        children: [
          DetailRow(
            label: 'Check-in Date',
            value: DateTimeService.format(
              checkInDate,
              format: 'EEEE d\'${DateTimeService.getDaySuffix(checkInDate?.day)}\' MMMM',
            ),
          ),
          DetailRow(
            label: 'Check-Out Date',
            value: DateTimeService.format(
              checkOutDate,
              format: 'EEEE d\'${DateTimeService.getDaySuffix(checkOutDate?.day)}\' MMMM',
            ),
          ),
          DetailRow(
            label: 'CheckIn - CheckOut Time',
            value: '${DateTimeService.format(checkInTime, format: 'h:mm a')} - ${DateTimeService.format(checkOutTime, format: 'h:mm a')}',
          ),
          DetailRow(
            label: 'Location',
            value: address ?? 'Not specified',
          ),
          DetailRow(
            label: 'Apartment Host',
            value: hostName ?? 'Not specified',
          ),
          DetailRow(
            label: 'Total Price',
            value: MoneyServiceV2.formatNaira(totalPrice),
          ),
        ],
      ),
    );
  }
}
class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const Gap(20),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
