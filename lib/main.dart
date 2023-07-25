import 'package:optigram/services/local_notice.service.dart';
import 'package:flutter/material.dart';
import 'package:optigram/views/pages/insta.view.dart';
import 'package:optigram/services/app_lifecycle.service_observer.dart';
import 'package:provider/provider.dart';

import 'package:optigram/controllers/timer.notifier.dart';
import 'package:optigram/data/config/theme.data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNoticeService().setup();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TimerNotifier()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();

    return MaterialApp(title: 'Optigram', theme: ThemeConfig.appData, routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => InstaPage(appLifecycleObserver),
    });
  }
}
