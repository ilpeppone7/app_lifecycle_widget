import 'package:example/lifecycle_aware_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final RouteObserver<ModalRoute<dynamic>> routeObserver = RouteObserver<ModalRoute<dynamic>>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifecycleWidget Example',
      home: LifecycleAwarePage(),
      navigatorObservers: [
        routeObserver,
      ],
    );
  }
}