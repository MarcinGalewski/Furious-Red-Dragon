import 'package:flutter/material.dart';
import 'package:furious_red_dragon/constants.dart';
import 'package:furious_red_dragon/pages/home/add_room.dart';
import 'package:furious_red_dragon/pages/login_page.dart';
import 'package:furious_red_dragon/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/register_page.dart';

import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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

Future<bool> isInternet() async {
  bool connectivityResult = await (InternetConnection().hasInternetAccess);
  if (connectivityResult) {
    return true;
  } else {
    // Wifi detected but no internet connection found.
    return false;
  }
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
        RegisterPage.routeName: (context) => RegisterPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        HomePage.routeName: (context) => const HomePage(),
        AddRoomPage.routeName: (context) => const AddRoomPage(),
      },
      navigatorKey: MyApp.navigatorKey,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: kFuriousRedColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
    );
  }
}
