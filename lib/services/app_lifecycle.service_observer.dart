import 'package:flutter/material.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  Function _onResume = () {};
  AppLifecycleState _currentState = AppLifecycleState.resumed;
  AppLifecycleObserver();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _currentState = state;
    if (state == AppLifecycleState.resumed) {
      _onResume!();
    }
  }

  set onResume(Function onResume) => _onResume = onResume;

  get userOnApp => _currentState == AppLifecycleState.resumed;
}
