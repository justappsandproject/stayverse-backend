import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stayvers_agent/core/commonLibs/common_libs.dart';
import 'package:stayvers_agent/core/extension/extension.dart';
import 'package:stayvers_agent/core/util/app/validator.dart';
import 'package:stayvers_agent/core/util/style/app_colors.dart';
import 'package:stayvers_agent/core/util/textField/app_text_field.dart';
import 'package:stayvers_agent/feature/chefOwner/controller/chef_profile_controller.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/add_experience_request.dart';
import 'package:stayvers_agent/feature/chefOwner/view/component/chef_location_search.dart';
import 'package:stayvers_agent/shared/app_back_button.dart';
import 'package:stayvers_agent/shared/buttons.dart';
import 'package:stayvers_agent/shared/date_time_picker.dart';
import 'package:stayvers_agent/shared/skeleton.dart';

class ExperienceForm extends ConsumerStatefulWidget {
  static const route = '/ExperienceForm';
  const ExperienceForm({super.key});

  @override
  ConsumerState<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends ConsumerState<ExperienceForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _locationFocusNode = FocusNode();

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  String? _startDateIso;
  String? _endDateIso;

  String? _selectedPlaceId;
  bool _stayVerseJob = false;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrimSkeleton(
      isBusy: ref.watch(chefController).isBusy,
      appBar: AppBar(
        surfaceTintColor: AppColors.white,
        leading: const AppBackButton(),
      ),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 18),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              'Add Experience'.txt(
                size: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
              23.sbH,
              AppTextField(
                title: 'Title',
                controller: _titleController,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                validator: (value) => Validator.validateEmptyField(value),
              ),
              27.sbH,
              AppTextField(
                title: 'Company or organization',
                controller: _companyController,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                validator: (value) => Validator.validateEmptyField(value),
              ),
              27.sbH,
              AppTextField(
                title: 'Description',
                controller: _descriptionController,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                minLines: 3,
                borderRadius: BorderRadius.circular(17),
                validator: (value) => Validator.validateEmptyField(value),
              ),
              27.sbH,
              ExperienceDatePicker(
                label: 'Start Date',
                controller: _startDateController, // Pass the controller
                onDateSelected: (displayDate, isoDate) {
                  setState(() {
                    _startDateIso = isoDate;
                  });
                },
                validator: (value) => Validator.validateEmptyField(value),
              ),
              27.sbH,
              ExperienceDatePicker(
                label: 'End Date',
                controller: _endDateController,
                onDateSelected: (displayDate, isoDate) {
                  //_endDateController.text = displayDate;
                  setState(() {
                    _endDateIso = isoDate;
                  });
                  
                },
              ),
              27.sbH,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: $styles.text.h4.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  10.sbH,
                  ChefLocationSearch(
                    onLocationSelected: (placeId, location) {
                      _selectedPlaceId = placeId;
                      _locationController.text = location;
                    },
                    controller: _locationController,
                    focusNode: _locationFocusNode,
                  ),
                ],
              ),
              27.sbH,
              ExperienceOption(
                title: 'I got this job from Stayverse',
                isSelected: _stayVerseJob,
                onToggle: (val) {
                  setState(() {
                    _stayVerseJob = val;
                  });
                },
              ),
              const Divider(
                color: AppColors.greyF7,
              ),
              27.sbH,
              AppBtn.from(
                text: 'Save',
                expand: true,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                bgColor: AppColors.black,
                onPressed: () {
                  _submit();
                },
              ),
              17.sbH,
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final proceed = await ref.read(chefController.notifier).addExperience(
            ExperienceRequest(
              title: _titleController.text.trim(),
              company: _companyController.text.trim(),
              description: _descriptionController.text.trim(),
              startDate: _startDateIso,
              endDate: _endDateIso,
              address: _locationController.text.trim(),
              placeId: _selectedPlaceId,
              stayVerseJob: _stayVerseJob,
            ),
          );

      if (proceed) {
        ref.read(chefController.notifier).getChefStatus();
        $navigate.popUntil(1);
      }
    }
  }
}

class ExperienceOption extends StatefulWidget {
  final String title;
  final bool isSelected;
  final ValueChanged<bool> onToggle;
  const ExperienceOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  State<ExperienceOption> createState() => _ExperienceOptionState();
}

class _ExperienceOptionState extends State<ExperienceOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onToggle(!widget.isSelected);
      },
      child: Container(
        height: 30,
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.title.txt14(
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
            SizedBox(
              height: 10,
              child: Switch.adaptive(
                value: widget.isSelected,
                trackOutlineWidth: const WidgetStatePropertyAll(0),
                onChanged: widget.onToggle,
                thumbColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.white;
                    }
                    if (states.contains(WidgetState.selected)) {
                      return context.color.primary;
                    }
                    return Colors.white;
                  },
                ),
                trackColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.grey.shade100;
                    }
                    if (states.contains(WidgetState.selected)) {
                      return context.color.primary.withValues(alpha: 0.3);
                    }
                    return Colors.grey.shade300;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExperienceDatePicker extends StatefulWidget {
  final String label;
  final void Function(String displayDate, String isoDate) onDateSelected;
  final String? Function(String?)? validator;
  final TextEditingController controller; // Make controller required, not optional
  
  const ExperienceDatePicker({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.validator,
    required this.controller, // Make it required
  });

  @override
  State<ExperienceDatePicker> createState() => _ExperienceDatePickerState();
}

class _ExperienceDatePickerState extends State<ExperienceDatePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDatePicker(context),
      child: AppTextField(
        title: widget.label,
        readOnly: true,
        validator: widget.validator,
        controller: widget.controller, // Use the provided controller
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        onTap: () => _showDatePicker(context), // Also trigger date picker on tap of text field
      ),
    );
  }
  
  void _showDatePicker(BuildContext context) {
    showAppDatePicker(
      context,
      onConfirm: (date) {
        final displayDate = DateFormat('yyyy-MM-dd').format(date);
        final isoDate = date.toUtc().toIso8601String();
        
        setState(() {
          widget.controller.text = displayDate;
        });
        
        widget.onDateSelected(displayDate, isoDate);
      },
    );
  }
}