import 'package:flutter/material.dart';
import 'package:furious_red_dragon/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';
import 'settings_page.dart';
import 'package:furious_red_dragon/components/buttons.dart';
import 'package:furious_red_dragon/pages/welcome_page.dart';

class CustomPopup extends StatelessWidget {
  final String message;
  final IconData iconData;
  final Color backgroundColor;

  const CustomPopup({
    super.key,
    required this.message,
    required this.iconData,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 460,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors
              .black, // Możesz zmienić kolor obramowania na dowolny inny, jeśli chcesz
        ),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          const SizedBox(width: 8),
          kBigGap,
          Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          kBigGap,
          // IconButton(
          //   onPressed: () {
          //     // Add functionality for the info icon button if needed
          //   },
          //   icon: const Icon(Icons.info, size: 25, color: Colors.black),
          // ),
        ],
      ),
    );
  }
}

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

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
        title: const Text('Usuń konto'),
        actions: const <Widget>[],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Czy na pewno chcesz usunąć konto?',
              style: kGlobalTextStyle.copyWith(fontSize: 24),
            ),
            kBigGap,
            Text(
              'Uwaga! Ta czynność jest nieodwracalna!',
              style: kGlobalTextStyle.copyWith(
                  fontSize: 18, color: kFuriousRedColor),
            ),
            kBigGap,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallButton(
                  onTap: () {
                    Navigator.pop(context); // Close the current page
                  },
                  buttonTitle: 'Nie',
                ),
                kSmallGap,
                SmallButton(
                  onTap: () {
                    deleteUser(context);

                    // Przejście do podstrony delete_account.dart po kliknięciu "Usuń konto"
                  },
                  buttonTitle: ('Tak'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //void getBackToSplash(context) {
  //  Navigator.popUntil(context, ModalRoute.withName('/'));
  //}

  Future<void> deleteUser(context) async {
    var uuid = supabase.auth.currentUser?.id;
    var email = supabase.auth.currentUser?.email;
    final client = SupabaseClient('https://ubjqvkvameebwmsjujbd.supabase.co/',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVianF2a3ZhbWVlYndtc2p1amJkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5OTA2MjA1NSwiZXhwIjoyMDE0NjM4MDU1fQ.YLPceJ2EnaSBlM_FNeDlRJPp-WMzxySnM5uEgFe4jj0');
    await supabase.auth.signOut();
    try {
      await client.from('roles').delete().eq('email', email);
    } on Exception {}
    await client.auth.admin.deleteUser(uuid!);

    SettingsPage helper = const SettingsPage();
    helper.getBackToSplash(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountDeletedPage()),
    );
  }
}

class AccountDeletedPage extends StatefulWidget {
  const AccountDeletedPage({Key? key}) : super(key: key);

  @override
  _AccountDeletedPageState createState() => _AccountDeletedPageState();
}

class _AccountDeletedPageState extends State<AccountDeletedPage> {
  int _countdown = 10;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
        startCountdown();
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const WelcomePage(),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konto usunięte'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              margin: kSplashInputMargin,
              child: Image.asset(kMushuPath),
            ),
            const SizedBox(height: 20),
            kBigGap,
            kBigGap,
            Text(
              'Przykro nam, że nas opuszczasz!',
              style: kGlobalTextStyle.copyWith(fontSize: 24),
            ),
            kMediumGap,
            Text(
              'Za $_countdown sekund zostaniesz przekierowany na stronę główną.',
              style: kGlobalTextStyle.copyWith(fontSize: 18),
            ),
            kBigGap,
            kBigGap,
            kBigGap,
            kBigGap,
            kBigGap,
            kBigGap,
            kBigGap,
            const SizedBox(height: 20),
            const CustomPopup(
              message: 'Twoje konto zostało pomyślnie usunięte',
              iconData: Icons.check_circle,
              backgroundColor: kGoodGreenColor,
            ),
          ],
        ),
      ),
    );
  }
}
