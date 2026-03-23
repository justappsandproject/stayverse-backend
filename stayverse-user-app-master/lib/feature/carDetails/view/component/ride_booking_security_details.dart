import 'package:flutter_animate/flutter_animate.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';

class RideBookingSecurityDetails extends StatefulWidget {
  final bool isSelectable;
  final List<String>? preselected;
  final Function(List<String>)? onChanged;

  const RideBookingSecurityDetails({
    super.key,
    this.isSelectable = true,
    this.preselected,
    this.onChanged,
  });

  @override
  State<RideBookingSecurityDetails> createState() =>
      _RideBookingSecurityDetailsState();
}

class _RideBookingSecurityDetailsState
    extends State<RideBookingSecurityDetails> {
  final List<String> options = ["Bodyguards", "Police"];
  late List<String> selected;

  bool isSelected(String label) => selected.contains(label);

  @override
  void initState() {
    super.initState();
    selected = widget.preselected ?? [];
  }

  void updateSelection(String label, bool isSelected) {
    if (!widget.isSelectable) return;

    setState(() {
      if (isSelected) {
        selected.add(label);
      } else {
        selected.remove(label);
      }
    });

    widget.onChanged?.call(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security Details',
                style: $styles.text.h4.copyWith(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              const Gap(10),
              Text(
                widget.isSelectable
                    ? "Add Security Personnel (Optional)"
                    : "Added Security Personnel",
                style: $styles.text.body.copyWith(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              const Gap(20),
              SecurityCheckbox(
                label: "Bodyguards",
                value: isSelected("Bodyguards"),
                isSelectable: widget.isSelectable,
                onChanged: (v) => updateSelection("Bodyguards", v),
              ),
              const Gap(16),
              SecurityCheckbox(
                label: "Police",
                value: isSelected("Police"),
                isSelectable: widget.isSelectable,
                onChanged: (v) => updateSelection("Police", v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SecurityCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final bool isSelectable;
  final ValueChanged<bool> onChanged;

  const SecurityCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.isSelectable,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveColor = Colors.black.withOpacity(0.35);

    return GestureDetector(
      onTap: isSelectable ? () => onChanged(!value) : null,
      child: Row(
        children: [
          // CHECKBOX
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: value ? const Color(0xFFFBC036) : Colors.white,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: value ? Colors.black : inactiveColor,
              ),
            ),
            child: value
                ? Center(
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 12,
                    )
                        .animate(target: value ? 1 : 0)
                        .fadeIn(duration: 200.ms)
                        .scale(begin: const Offset(0.7, 0.7)),
                  )
                : null,
          ),

          const Gap(12),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: value ? Colors.black : inactiveColor,
              fontWeight: FontWeight.w400,
              decorationColor: inactiveColor,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}
