import 'package:stayvers_agent/core/commonLibs/common_libs.dart';

class RideSecurityDetails extends StatefulWidget {
  final List<String>? securityDetails;

  const RideSecurityDetails({super.key, this.securityDetails});

  @override
  State<RideSecurityDetails> createState() => _RideSecurityDetailsState();
}

class _RideSecurityDetailsState extends State<RideSecurityDetails> {
  bool addBodyguards = false;
  bool addPolice = false;

  @override
  void initState() {
    super.initState();
    _loadSecurityDetails();
  }

  void _loadSecurityDetails() {
    final details = widget.securityDetails ?? [];

    addBodyguards = details.contains("Bodyguards");
    addPolice = details.contains("police");
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
                color: Colors.black.withOpacity(0.03),
                spreadRadius: 1,
                blurRadius: 30,
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
                "Added Security Personnel",
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
                value: addBodyguards,
              ),
              const Gap(16),
              SecurityCheckbox(
                label: "Police",
                value: addPolice,
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

  const SecurityCheckbox({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveColor = Colors.black.withOpacity(0.35);

    return Row(
      children: [
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
              ? const Center(
                  child: Icon(Icons.check, color: Colors.black, size: 12))
              : null,
        ),
        const Gap(12),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: value ? Colors.black : inactiveColor,
            fontWeight: FontWeight.w400,
            decoration: value ? null : TextDecoration.lineThrough,
            decorationColor: inactiveColor,
            height: 0,
          ),
        ),
      ],
    );
  }
}
