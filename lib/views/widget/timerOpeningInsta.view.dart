import 'dart:async';

import 'package:flutter/material.dart';

class TimerOpeningInsta extends StatefulWidget {
  final int durationInSeconds;
  final Function onFinish;
  final Function? onCancel;

  const TimerOpeningInsta({super.key, required this.durationInSeconds, required this.onFinish, this.onCancel});

  @override
  State<TimerOpeningInsta> createState() => _TimerOpeningInstaState();
}

class _TimerOpeningInstaState extends State<TimerOpeningInsta> {
  late Timer _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.durationInSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          widget.onFinish();
        }
      });
    });
  }

  void _cancelTimer() {
    _timer.cancel();
    setState(() {
      _secondsRemaining = 0;
    });

    if (widget.onCancel != null) {
      widget.onCancel!();
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedTime = '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  final TextStyle _textStyle = TextStyle(color: Colors.grey[300], fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Instagram will open in ", style: _textStyle),
          Text(
            _formatTime(_secondsRemaining),
            style: _textStyle,
          ),
        ],
      ),
      TextButton(onPressed: _cancelTimer, child: const Text('Cancel')),
    ]);
  }
}
