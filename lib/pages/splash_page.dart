import 'package:flutter/material.dart';
import 'package:furious_red_dragon/main.dart';
import 'package:furious_red_dragon/pages/home_page.dart';
import 'package:furious_red_dragon/pages/welcome_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
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
