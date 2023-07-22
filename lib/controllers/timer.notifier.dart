import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerNotifier extends ChangeNotifier {
  Timer _timer = Timer(const Duration(seconds: 0), () {});
  int _secondsRemaining = 0;
  Function? onFinish;

  void startTimer(int durationInSeconds, {Function? onFinish}) {
    _secondsRemaining = durationInSeconds;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        _timer.cancel();
        onFinish!();
      }
      notifyListeners(); // Notify listeners on every tick
    });
  }

  void cancelTimer() {
    _timer.cancel();
    _secondsRemaining = 0; // Reset the counter when stopping the timer
    notifyListeners();
  }

  bool get isTimerRunning => _secondsRemaining > 0;

  get secondsRemaining => _secondsRemaining;
}
