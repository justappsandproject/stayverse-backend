import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';

enum ServiceType {
  chef('chef', 'Chef'),
  apartmentOwner('apartment', 'Apartment Owner'),
  carOwner('ride', 'Car Owner');

  final String id;
  final String value;

  const ServiceType(this.id, this.value);

  static ServiceType fromString(String? value) {
    if (value == null) return ServiceType.apartmentOwner;

    return ServiceType.values.firstWhere(
      (type) => type.id == value,
      orElse: () => ServiceType.apartmentOwner,
    );
  }
}

enum LoginRoute {
  emailNotVerified,
  success,
  failed;
}

enum Status {
  approved,
  cancelled,
  pending;
}

enum ProviderMode { create, edit }

// Enums for Transaction
enum TransactionType {
  credit('credit', 'Credit'),
  debit('debit', 'Debit');

  final String id;
  final String value;

  const TransactionType(this.id, this.value);

  static TransactionType? fromString(String? value) {
    return TransactionType.values.firstOrNullWhere(
          (type) => type.id == value,
        ) ??
        TransactionType.credit;
  }

  String get displayName => value;
}

enum TransactionStatus {
  successful('successful', 'Successful', ['success']),
  pending('pending', 'Pending', ['pending']),
  failed('failed', 'Failed', ['failed']),
  refunded('refunded', 'Refunded', ['refunded']),
  reversed('reversed', 'Reversed', ['reversed']);

  final String id;
  final String value;
  final List<String> aliases;

  const TransactionStatus(this.id, this.value, this.aliases);

  static TransactionStatus? fromString(String? value) {
    return TransactionStatus.values.firstOrNullWhere(
          (status) => status.id == value || status.aliases.contains(value),
        ) ??
        TransactionStatus.pending;
  }

  String get displayName => value;

  Color get color {
    switch (this) {
      case TransactionStatus.successful:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.refunded:
        return Colors.red;
      case TransactionStatus.reversed:
        return Colors.red;
    }
  }
}

enum KycVerificationStatus {
  pending(color: Colors.amber, label: 'Pending'),
  // ignore: constant_identifier_names
  in_review(color: Colors.grey, label: 'In Review'),
  approved(color: Colors.green, label: 'Approved'),
  declined(color: Colors.red, label: 'Declined');

  const KycVerificationStatus({required this.color, required this.label});
  final Color color;
  final String label;

  static KycVerificationStatus? fromName(String? name) {
    if (name == null) return null;
    return KycVerificationStatus.values
        .firstOrNullWhere((e) => e.name.toLowerCase() == name);
  }
}

enum ExtraDataType {
  proposal('proposal'),
  proposalAction('proposalAction');

  final String id;

  const ExtraDataType(this.id);

  static ExtraDataType? fromString(String? value) {
    return ExtraDataType.values.firstOrNullWhere(
      (type) => type.id == value,
    );
  }
}

enum ProposalStatus {
  accepted('accepted', 'Accepted'),
  rejected('rejected', 'Rejected'),
  pending('pending', 'Pending');

  final String id;
  final String value;

  const ProposalStatus(this.id, this.value);

  static ProposalStatus? fromString(String? value) {
    return ProposalStatus.values.firstOrNullWhere(
      (status) => status.id.toLowerCase() == value?.toLowerCase(),
    );
  }
}
