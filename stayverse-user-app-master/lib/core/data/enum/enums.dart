import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';

enum LoginRoute {
  emailNotVerified,
  success,
  failed;
}

enum Roles {
  user,
  admin;

  /// API sends lowercase role strings (`user`, `admin`, `agent`). Never throws.
  static Roles? tryParse(dynamic value) {
    if (value == null) return null;
    if (value is List && value.isNotEmpty) {
      return tryParse(value.first);
    }
    final s = value.toString().trim().toLowerCase();
    if (s.isEmpty) return null;
    return Roles.values.firstOrNullWhere((e) => e.name.toLowerCase() == s);
  }
}

enum ServiceType {
  apartment(value: 'Apartment', apiPoint: 'apartment'),
  chefs(value: 'chefs', apiPoint: 'chef'),
  rides(value: 'rides', apiPoint: 'ride');

  final String value;
  final String apiPoint;

  const ServiceType({required this.value, required this.apiPoint});

  static ServiceType? fromValue(String? value) {
    return ServiceType.values.firstOrNullWhere(
      (e) =>
          e.value.toLowerCase() == value?.toLowerCase() ||
          e.apiPoint.toLowerCase() == value?.toLowerCase(),
    );
  }
}

enum ActionFavourite { add, remove }

enum BookingStatus {
  pending,
  completed,
  rejected,
  accepted;
}

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
    final n = name.trim().toLowerCase();
    if (n == 'verified') return KycVerificationStatus.approved;
    return KycVerificationStatus.values
        .firstOrNullWhere((e) => e.name.toLowerCase() == n);
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
  accepted('accepted', 'Accepted', '\u2705'),
  rejected('rejected', 'Rejected', '\u274C'),
  pending('pending', 'Pending', '\u23F3');

  final String id;
  final String value;
  final String emoji;

  const ProposalStatus(this.id, this.value, this.emoji);

  static ProposalStatus? fromString(String? value) {
    return ProposalStatus.values.firstOrNullWhere(
      (status) => status.id.toLowerCase() == value?.toLowerCase(),
    );
  }
}

enum UserExperiences {
  user,
  host,
}
