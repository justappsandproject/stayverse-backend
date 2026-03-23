import 'dart:async';

import 'package:stayverse/core/commonLibs/common_libs.dart';

class CoolDownButton extends StatefulWidget {
  final Widget Function(BuildContext, Function) builder;
  final int durationInSeconds;

  const CoolDownButton(
      {required this.builder, this.durationInSeconds = 60, super.key});

  @override
  CoolDownButtonState createState() => CoolDownButtonState();
}

class CoolDownButtonState extends State<CoolDownButton> {
  bool showChild = true;
  int remainingTime = 0;
  Timer? timer;

  void startCooldown() {
    _startCooldown();
  }

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  void _startCooldown() {
    setState(() {
      showChild = false;
      remainingTime = widget.durationInSeconds;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--;
      });

      if (remainingTime == 0) {
        setState(() {
          showChild = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showChild
        ? widget.builder(
            context,
            startCooldown,
          )
        : Text(
            _formatTime(remainingTime),
            style: $styles.text.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.8),
            ),
          );
  }

  String _formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;

    return '${_twoDigits(minutes)}:${_twoDigits(remainingSeconds)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
