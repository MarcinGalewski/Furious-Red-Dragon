import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furious_red_dragon/main.dart';
import 'package:furious_red_dragon/pages/home_page.dart';
import 'package:furious_red_dragon/pages/welcome_page.dart';
import 'package:furious_red_dragon/pages/no_internet.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();

  static const routeName = '/';
}

class _SplashPageState extends State<SplashPage> {
  late StreamSubscription subscription;
  bool firstRun = true;

  @override
  void initState() {
    super.initState();
    _redirect();
    getConnectivity();
  }

  getConnectivity() => subscription =
          InternetConnection().onStatusChange.listen((InternetStatus status) {
        switch (status) {
          case InternetStatus.connected:
            if (firstRun) {
              firstRun = false;
            } else {
              Navigator.pop(context);
            }
            break;
          case InternetStatus.disconnected:
            firstRun = false;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoInternetDialog()),
            );
            break;
        }
      });

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    if (session != null) {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } else {
      Navigator.pushReplacementNamed(context, WelcomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
