import 'package:flutter/material.dart';
import 'package:furious_red_dragon/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants.dart';
import 'settings_page.dart';
import 'package:furious_red_dragon/components/buttons.dart';

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
  }
}
