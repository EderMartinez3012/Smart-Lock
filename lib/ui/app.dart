import 'package:flutter/material.dart';
import 'home/widget/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Lock',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'SFProDisplay'),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
