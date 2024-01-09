import 'package:flutter/material.dart';
import 'package:furious_red_dragon/main.dart';
import 'package:furious_red_dragon/pages/home/account_page.dart';
import 'package:furious_red_dragon/pages/home/help_page.dart';
import 'package:furious_red_dragon/pages/home/history_page.dart';
import 'package:furious_red_dragon/pages/home/scanner_page.dart';
import 'package:furious_red_dragon/pages/home/settings_page.dart';
import 'package:furious_red_dragon/components/nav_tabs.dart';
import 'package:furious_red_dragon/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          backgroundColor: kFuriousRedColor,
          title: FutureBuilder<String>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Witaj!');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var userName = snapshot.data ?? 'Szef';
                return Text('Witaj, $userName');
              }
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InkWell(
                onTap: () {
                  // Przenieś się do innej strony po kliknięciu
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                child: const Icon(Icons.settings),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const NavTabs(),
        body: const TabBarView(
          children: [
            AccountPage(),
            HistoryPage(),
            ScannerPage(),
            HelpPage(),
          ],
        ),
      ),
    );
  }

  Future<String> getUserName() async {
    var response = await supabase
        .from('roles')
        .select('name')
        .eq('user_id', supabase.auth.currentUser?.id)
        .single();

    return response['name'] as String;
  }
}
