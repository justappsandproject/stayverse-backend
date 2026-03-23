import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/service/toast_service.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:intl/intl.dart';
import 'package:stayvers_agent/shared/date_time_picker.dart';

class ChefProposalDialog extends StatefulWidget {
  final Function(String title, double price, DateTime completionDateTime)
      onSubmit;

  const ChefProposalDialog({
    super.key,
    required this.onSubmit,
  });

  @override
  State<ChefProposalDialog> createState() => _ChefProposalDialogState();
}

class _ChefProposalDialogState extends State<ChefProposalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _completionDateTime;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _selectDateTime() {
    showAppDateTimePicker(
      context,
      onConfirm: (dateTime) {
        setState(() {
          _completionDateTime = dateTime;
        });
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_completionDateTime == null) {
        BrimToast.showError('Please select a completion date and time',
            title: 'Select Completion Date & Time');
        return;
      }

      final title = _titleController.text.trim();
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      Navigator.of(context).pop();
      widget.onSubmit(title, price, _completionDateTime!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Proposal',
                  style: $styles.text.h3.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.color.inverseSurface,
                  ),
                ),
                const Gap(8),
                Text(
                  'Enter the details for your chef proposal',
                  style: $styles.text.bodySmall.copyWith(
                    color: context.color.onSurface.withOpacity(0.6),
                  ),
                ),
                const Gap(24),
                TextFormField(
                  controller: _titleController,
                  minLines: 3,
                  maxLines: 5,
                  style: $styles.text.body.copyWith(
                    color: context.color.onSurface,
                  ),
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.start,
                  inputFormatters: [MoneyFormatter()],
                  decoration: InputDecoration(
                    labelText: 'Proposal Description',
                    hintText: 'e.g., Private Dinner Service',
                    labelStyle: $styles.text.bodySmall.copyWith(
                      color: context.color.onSurface.withOpacity(0.6),
                    ),
                    hintStyle: $styles.text.bodySmall.copyWith(
                      color: context.color.onSurface.withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: context.color.surface,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    if (value.trim().length < 3) {
                      return 'Title must be at least 3 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const Gap(16),
                TextFormField(
                  controller: _priceController,
                  style: $styles.text.body.copyWith(
                    color: context.color.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: '0.00',
                    prefixText: 'N ',
                    labelStyle: $styles.text.bodySmall.copyWith(
                      color: context.color.onSurface.withOpacity(0.6),
                    ),
                    hintStyle: $styles.text.bodySmall.copyWith(
                      color: context.color.onSurface.withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: context.color.surface,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a price';
                    }
                    final price = double.tryParse(value.trim());
                    if (price == null) {
                      return 'Please enter a valid price';
                    }
                    if (price <= 0) {
                      return 'Price must be greater than 0';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
                const Gap(16),
                InkWell(
                  onTap: _selectDateTime,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.color.onSurface.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: context.color.surface,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: context.color.onSurface.withOpacity(0.6),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Completion Date & Time',
                                style: $styles.text.bodySmall.copyWith(
                                  color:
                                      context.color.onSurface.withOpacity(0.6),
                                ),
                              ),
                              const Gap(4),
                              Text(
                                _completionDateTime != null
                                    ? _formatDateTime(_completionDateTime!)
                                    : 'Select date and time',
                                style: $styles.text.body.copyWith(
                                  color: _completionDateTime != null
                                      ? context.color.onSurface
                                      : context.color.onSurface
                                          .withOpacity(0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: context.color.onSurface.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: AppBtn.from(
                        text: 'Cancel',
                        expand: true,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                        bgColor: AppColors.white,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: AppBtn.from(
                        text: 'Create',
                        expand: true,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                        bgColor: AppColors.black,
                        onPressed: _handleSubmit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
