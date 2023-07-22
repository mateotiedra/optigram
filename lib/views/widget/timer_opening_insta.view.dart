import 'dart:async';

import 'package:flutter/material.dart';

class TimerOpeningInsta extends StatelessWidget {
  int secondsRemaining;
  final Function() cancelTimer;

  TimerOpeningInsta({super.key, required this.secondsRemaining, required this.cancelTimer});

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
            _formatTime(secondsRemaining),
            style: _textStyle,
          ),
        ],
      ),
      TextButton(onPressed: cancelTimer, child: const Text('Cancel')),
    ]);
  }
}
