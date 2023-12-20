import 'package:flutter/material.dart';
import 'package:furious_red_dragon/main.dart';
import 'package:furious_red_dragon/pages/welcome_page.dart';
import 'package:furious_red_dragon/pages/splash_page.dart';
import 'delete_account.dart'; // Załóżmy, że plik delete_account.dart znajduje się w tym samym folderze co ten plik
import 'package:furious_red_dragon/components/buttons.dart';
import '../../constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        )),
        backgroundColor: kFuriousRedColor,
        title: const Text('Ustawienia', style: TextStyle(color: Colors.white)),
        actions: const <Widget>[],
      ),
      body: Material(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ustawienia',
                style: kGlobalTextStyle.copyWith(fontSize: 32),
              ),
              kBigGap,
              BigWhiteButton(
                onTap: () {
                  print('Zmiana hasła');
                },
                buttonTitle: ('Zmień hasło'),
              ),
              kMediumGap,
              BigWhiteButton(
                onTap: () {
                  // Przejście do podstrony delete_account.dart po kliknięciu "Usuń konto"
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DeleteAccountPage()),
                  );
                },
                buttonTitle: ('Usuń konto'),
              ),
              kMediumGap,
              BigWhiteButton(
                  onTap: () async {
                    await supabase.auth
                        .signOut()
                        .then((value) => getBackToSplash(context));
                  },
                  buttonTitle: 'Wyloguj')
            ],
          ),
        ),
      ),
    );
  }

  void getBackToSplash(context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    Navigator.pushNamed(context, WelcomePage.routeName);
  }
}
