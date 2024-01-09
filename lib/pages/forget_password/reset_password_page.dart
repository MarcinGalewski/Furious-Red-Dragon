import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furious_red_dragon/components/buttons.dart';
import 'package:furious_red_dragon/components/input.dart';
import 'package:furious_red_dragon/components/splash_back_button.dart';
import 'package:furious_red_dragon/constants.dart';
import 'package:furious_red_dragon/main.dart';
import 'package:furious_red_dragon/pages/home_page.dart';
import 'package:furious_red_dragon/pages/splash_page.dart';
import 'package:furious_red_dragon/pages/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:furious_red_dragon/pages/home/settings_page.dart';

// iasdasdgnore: must_be_immutable
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  static const routeName = '/resetPasswordPage';

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPage();
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  bool ifReset = false;
  TextEditingController oldPasswordController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();

  TextEditingController repeatNewPasswordController = TextEditingController();

  final userCopy = supabase.auth.currentUser;
  // Store the context
  BuildContext? _context;

  // Function to show a SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Store the context
    _context = context;
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
        title: const Text('Ustaw nowe hasło'),
        actions: const <Widget>[],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: kSplashInputMargin,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
              ),
              CustomTextField(
                labelText: 'Nowe hasło',
                controller: newPasswordController,
                obscureText: true, // Hide entered characters with asterisks
              ),
              CustomTextField(
                labelText: 'Powtórz nowe hasło',
                controller: repeatNewPasswordController,
                obscureText: true,
              ),
              kBigGap,
              BigRedButton(
                onTap: () async {
                  if (ifReset) return;
                  ifReset = true;
                  // Empty validation
                  if (newPasswordController.text.isEmpty ||
                      repeatNewPasswordController.text.isEmpty) {
                    _showSnackBar('Wypełnij wszystkie pola');
                    return;
                  }

                  //Password validation
                  if (newPasswordController.text !=
                      repeatNewPasswordController.text) {
                    newPasswordController.text = '';
                    repeatNewPasswordController.text = '';
                    _showSnackBar('Hasła nie są identyczne');
                    return;
                  }

                  // New password validation
                  try {
                    //final correctOldPass = await supabase.auth.admin.password;
                    final UserResponse res = await supabase.auth.updateUser(
                      UserAttributes(
                        password: newPasswordController.text,
                      ),
                    );
                    final User? updatedUser = res.user;
                  } on AuthException catch (authError) {
                    if (authError.statusCode == '422') {
                      _showSnackBar(
                          'Nowe hasło musi być inne od starego hasła!');
                      ifReset = false;
                      return;
                    }
                    print('Błąd zmiany hasła: $authError');
                    ifReset = false;
                    return;
                  }
                  _showSnackBar('Hasło zostało zmienione!');
                  Navigator.pushNamed(context, HomePage.routeName);
                },
                buttonTitle: 'Zmień hasło',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
