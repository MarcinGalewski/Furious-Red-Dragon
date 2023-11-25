import 'package:flutter/material.dart';
import 'package:furious_red_dragon/components/buttons.dart';
import 'package:furious_red_dragon/components/splash_back_button.dart';
import 'package:furious_red_dragon/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:furious_red_dragon/components/input.dart';
import 'package:furious_red_dragon/pages/home_page.dart';
import 'package:furious_red_dragon/pages/forget_password/email_check_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const routeName = '/loginPage';

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    TextEditingController passwordController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 70,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.only(left: 30, top: 30),
          child: SplashBackButton(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: kSplashInputMargin,
                child: Image.asset(
                  kDragonLogoPath,
                  width: kScreenWidth * 0.35,
                ),
                ForgotPasswordText(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EmailCheckPage()));
                  },
                ),
                kBigGap,
                BigRedButton(
                  onTap: () async {
                    try {
                      final AuthResponse res =
                          await supabase.auth.signInWithPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    } on AuthException catch (authError) {
                      print('Błąd logowania: $authError');
                      _showErrorDialog(context, authError.message);
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  buttonTitle: 'Zaloguj się',
              ),
              Container(
                margin: kSplashInputMargin,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Zaloguj się, aby zacząć inwentaryzację!',
                    textAlign: TextAlign.center,
                    style: kGlobalTextStyle.copyWith(fontSize: 24),
                  ),
                ),
              ),
              CustomTextField(
                labelText: 'Email',
                controller: emailController,
              ),
              CustomTextField(
                labelText: 'Hasło',
                controller: passwordController,
                obscureText: true,
              ),
              kBigGap,
              BigRedButton(
                onTap: () async {
                  try {
                    final AuthResponse res =
                        await supabase.auth.signInWithPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  } on AuthException catch (authError) {
                    print('Błąd logowania: $authError');
                    _showErrorDialog(context, authError.message);
                    return;
                  }
                  Navigator.of(context)
                      .pushReplacementNamed(HomePage.routeName);
                },
                buttonTitle: 'Zaloguj się',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Błąd logowania'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
