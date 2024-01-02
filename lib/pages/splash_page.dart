import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furious_red_dragon/components/buttons.dart';
import 'package:furious_red_dragon/constants.dart';
import 'package:furious_red_dragon/pages/no_internet.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'login_page.dart';
import 'register_page.dart';

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
    getConnectivity();
  }

  getConnectivity() =>
      subscription = InternetConnection().onStatusChange.listen((InternetStatus status) {
        switch (status) {
          case InternetStatus.connected:
            if(firstRun) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: kSplashInputMargin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: kSplashInputMargin,
              child: Image.asset(kDragonLogoPath, width: kScreenWidth * 0.5),
            ),
            Container(
              color: Colors.white,
              child: Text(
                'WŚCIEKŁY CZERWONY SMOK',
                textAlign: TextAlign.center,
                style: kGlobalTextStyle.copyWith(
                  color: kFuriousRedColor,
                  fontSize: 26,
                  fontFamily: 'Ruslan Display',
                  height: 1.75,
                ),
              ),
            ),
            kBigGap,
            SizedBox(
              width: double.infinity,
              child: BigRedButton(
                  onTap: () {
                    Navigator.pushNamed(context, LoginPage.routeName);
                  },
                  buttonTitle: 'Zaloguj się'),
            ),
            kBigGap,
            SizedBox(
              width: double.infinity,
              child: BigWhiteButton(
                  borderColor: kFuriousRedColor,
                  onTap: () {
                    Navigator.pushNamed(context, RegisterPage.routeName);
                  },
                  buttonTitle: 'Zarejestruj się'),
            ),
          ],
        ),
      ),
    );
  }
}
