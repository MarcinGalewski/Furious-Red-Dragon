import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furious_red_dragon/main.dart';
import 'package:furious_red_dragon/pages/home_page.dart';
import 'package:furious_red_dragon/pages/welcome_page.dart';
import 'package:furious_red_dragon/pages/no_internet.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();

  static const routeName = '/';
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    Navigator.pushReplacementNamed(context, NoInternetDialog.routeName);
    if (session != null) {
      Navigator.pushNamed(context, HomePage.routeName);
    } else {
      Navigator.pushNamed(context, WelcomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
