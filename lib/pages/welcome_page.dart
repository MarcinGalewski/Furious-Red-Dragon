import 'package:flutter/material.dart';
import 'package:furious_red_dragon/pages/register_page.dart';

import '../components/buttons.dart';
import '../constants.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const routeName = '/welcomePage';

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
