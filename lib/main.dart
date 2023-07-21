import 'package:optigram/services/local_notice.service.dart';
import 'package:flutter/material.dart';
import 'package:optigram/views/pages/insta.view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNoticeService().setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Optigram', routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => const InstaPage(),
    });
  }
}
