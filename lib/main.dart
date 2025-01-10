import 'package:firebase_core/firebase_core.dart';
import 'package:pbm_project1_uas/views/home_page.dart';

import 'package:pbm_project1_uas/views/login_page.dart';
import 'package:pbm_project1_uas/views/register.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      routes: {
        '/register': (context) => const Register(),
        '/login': (context) => const LoginPage(),
        '/': (context) => const HomePage(),
      },
      initialRoute: "/",
    );
  }
}
