import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furious_red_dragon/components/buttons.dart';
import 'package:furious_red_dragon/components/input.dart';
import 'package:furious_red_dragon/components/splash_back_button.dart';
import 'package:furious_red_dragon/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import 'login_page.dart';

@override
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const routeName = '/registerPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool ifRegistered = false;

  bool ifConfirmed = false;

  // Controllers for email, password, and repeat password fields
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController repeatPasswordController =
      TextEditingController();

  final TextEditingController tokenController = TextEditingController();

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

  // Function to show a Token Confirmation Dialog
  Future<void> _showTokenConfirmationDialog(String email, String name) async {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    showDialog(
      context: _context!,
      builder: (context) {
        return Builder(
          builder: (BuildContext context) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: const Text('Potwierdź rejestrację'),
              ),
              body: AlertDialog(
                content: Column(
                  children: [
                    const Text(
                        'Wprowadź token potwierdzający rejestrację, który został wysłany na Twój adres e-mail.'),
                    kMediumGap,
                    TextFormField(
                      controller: tokenController,
                      decoration: const InputDecoration(labelText: 'Token'),
                    ),
                  ],
                ),
                actions: [
                  BigRedButton(
                    onTap: () async {
                      if (ifConfirmed == true) return;
                      ifConfirmed = true;
                      try {
                        // Verify the token with Supabase
                        await supabase.auth.verifyOTP(
                          type: OtpType.signup,
                          token: tokenController.text,
                          email: email,
                        );
                        // Handle verification error
                      } catch (error) {
                        _showSnackBar(
                            'Nieudana weryfikacja tokena. Sprawdź poprawność tokena.');
                        retryRegistration();
                        return;
                      }

                      // Add new user
                      await supabase.from('roles').insert([
                        {
                          'name': name,
                          'status': 'admin',
                          'email': email,
                        }
                      ]);

                      // Close the dialog
                      if (!context.mounted) return;
                      Navigator.pop(context);

                      _showSnackBar('Zarejestrowano pomyślnie!');

                      // Navigate to login page
                      Navigator.pushNamed(context, LoginPage.routeName);
                      await supabase.auth.signOut();
                    },
                    buttonTitle: 'Potwierdź',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Reseting flags after invalid registration
  void retryRegistration() {
    ifRegistered = false;
    ifConfirmed = false;
  }

  @override
  Widget build(BuildContext context) {
    // Store the context
    _context = context;

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
                child: Image.asset(kDragonLogoPath, width: kScreenWidth * 0.35),
              ),
              Container(
                margin: kSplashInputMargin,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Załóż konto dla swojej firmy i zacznij inwentaryzować już dziś!',
                    textAlign: TextAlign.center,
                    style: kGlobalTextStyle.copyWith(fontSize: 24),
                  ),
                ),
              ),
              CustomTextField(
                labelText: 'Imię',
                controller: nameController,
              ),
              CustomTextField(
                labelText: 'Email',
                controller: emailController,
              ),
              CustomTextField(
                labelText: 'Hasło',
                controller: passwordController,
                obscureText: true, // Hide entered characters with asterisks
              ),
              CustomTextField(
                labelText: 'Powtórz hasło',
                controller: repeatPasswordController,
                obscureText: true,
              ),
              kBigGap,
              BigRedButton(
                onTap: () async {
                  register();
                },
                buttonTitle: 'Zarejestruj się',
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void register() async {
    if (ifRegistered) return;
    ifRegistered = true;

    validateRegister();

    try {
      //Try to register in Supabase
      await supabase.auth.signUp(
          password: passwordController.text, email: emailController.text);

      // Checking if email is already registered
      final data = await supabase
          .from('roles')
          .select('email')
          .eq('email', emailController.text);
      final count = data.length;
      if (count == 0) {
        await _showTokenConfirmationDialog(
            emailController.text, nameController.text);
        resetInputs();
      } else {
        _showSnackBar('Email już został zarejestrowany');
        retryRegistration();
      }
      // Catch errors
    } on AuthException catch (error) {
      if (error.statusCode == '429') {
        // Handle email limit exceeded error
        _showSnackBar('Przekroczono limit wysyłania wiadomości e-mail');
        retryRegistration();
      } else {
        // Display error message
        _showSnackBar(error.message);
        retryRegistration();
      }
    } on TimeoutException catch (error) {
      // Handle TimeoutException
      _showSnackBar('Przekroczono czas oczekiwania: ${error.message}');
      retryRegistration();
    } on Exception catch (error) {
      // Error registration
      _showSnackBar(
          'Rejestracja nieudana. Wystąpił nieznany wyjątek: ${error.toString()}');
      retryRegistration();
    }
  }

  /// Validates register - handled cases:
  /// - empty inputs
  /// - passwords don't match
  /// - bad email format
  void validateRegister() {
    // Empty validation
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        repeatPasswordController.text.isEmpty) {
      _showSnackBar('Wypełnij wszystkie pola');
      retryRegistration();
      return;
    }

    // Password validation
    if (passwordController.text != repeatPasswordController.text) {
      _showSnackBar('Hasła nie są identyczne');
      retryRegistration();
      return;
    }

    // E-mail validation
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(emailController.text)) {
      _showSnackBar('Wpisz poprawny adres e-mail');
      retryRegistration();
      return;
    }
  }

  /// Resets all inputs and variables
  void resetInputs() {
    nameController.text = '';
    emailController.text = '';
    passwordController.text = '';
    repeatPasswordController.text = '';
    ifRegistered = false;
    ifConfirmed = false;
  }
}
