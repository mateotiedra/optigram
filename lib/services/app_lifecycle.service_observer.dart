import 'package:flutter/material.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final Function? onResume;
  AppLifecycleState _currentState = AppLifecycleState.resumed;
  AppLifecycleObserver({this.onResume});
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _currentState = state;
    if (state == AppLifecycleState.resumed) {
      onResume!();
      print('App Resumed');
    }
  }

  get userOnApp => _currentState == AppLifecycleState.resumed;
}
