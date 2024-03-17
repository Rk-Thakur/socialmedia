import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tweet/firebase_options.dart';
import 'package:tweet/theme/dark_theme.dart';

import 'auth/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      darkTheme: darkTheme,
      home: const AuthPage(),
    );
  }
}
