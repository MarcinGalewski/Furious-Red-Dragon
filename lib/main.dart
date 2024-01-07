import 'package:flutter/material.dart';
import 'package:furious_red_dragon/constants.dart';
import 'package:furious_red_dragon/pages/home/add_room.dart';
import 'package:furious_red_dragon/pages/login_page.dart';
import 'package:furious_red_dragon/pages/no_internet.dart';
import 'package:furious_red_dragon/pages/welcome_page.dart';
import 'package:furious_red_dragon/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/register_page.dart';
import 'dart:async';

import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ubjqvkvameebwmsjujbd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVianF2a3ZhbWVlYndtc2p1amJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkwNjIwNTUsImV4cCI6MjAxNDYzODA1NX0.C0T-L8L_T5ny_gL2Mm4RAQJ36-DtZDoByAbLAqPcymk',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Furious Red Dragon',
      home: const SplashPage(),
      routes: {
        WelcomePage.routeName: (context) => const WelcomePage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        HomePage.routeName: (context) => const HomePage(),
        AddRoomPage.routeName: (context) => const AddRoomPage(),
        NoInternetDialog.routeName: (context) => const NoInternetDialog()
      },
      navigatorKey: MyApp.navigatorKey,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: kFuriousRedColor,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
