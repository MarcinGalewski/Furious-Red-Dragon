import 'package:flutter/material.dart';
import 'package:furious_red_dragon/components/buttons.dart';
import 'package:furious_red_dragon/components/splash_back_button.dart';
import 'package:furious_red_dragon/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';
import 'reset_password_page.dart';
import 'package:furious_red_dragon/pages/register_page.dart';
import 'package:furious_red_dragon/main.dart';
import 'package:furious_red_dragon/pages/login_page.dart';

import 'package:furious_red_dragon/components/input.dart';

class EmailCheckPage extends StatelessWidget {
  EmailCheckPage({super.key});

  static const routeName = '/EmailCheckPage';
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
    final TextEditingController emailController = TextEditingController();
    final TextEditingController tokenController = TextEditingController();
    final supabase = Supabase.instance.client;

    bool isLoggingIn = false;
    bool isTokenInvalid = false; // Track whether the token is invalid

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.only(left: 30, top: 30),
          child: SplashBackButton(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  margin: kSplashInputMargin,
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      kDragonLogoPath,
                      width: kScreenWidth * 0.35,
                    ),
                  ),
                ),
                CustomTextField(
                  labelText: 'Email',
                  controller: emailController,
                ),
                kBigGap,
                BigRedButton(
                  onTap: () async {
                    if (isLoggingIn) return;
                    isLoggingIn = true;

                    try {
                      // Krok 1: Wysłanie e-maila z tokenem resetującym hasło
                      await supabase.auth.resetPasswordForEmail(
                        emailController.text,
                        // redirectTo:
                        //     'io.supabase.flutterquickstart://login-callback/account/update-password',
                      );

//czy mail istnieje lub czy mail jest wyyslany
                      try {
                        final data = await supabase
                            .from('roles')
                            .select('email')
                            .eq('email', emailController.text)
                            .execute();
                        final count = data.data?.length ?? 0;

                        if (count == 0) {
                          // Brak maila, pokaż CustomPopup z odpowiednim komunikatem
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const CustomPopup(
                                  message: 'Brak maila w bazie danych.',
                                  iconData: Icons.error,
                                  backgroundColor: Colors.red,
                                ),
                                actions: [
                                  BigRedButton(
                                    onTap: () {
                                      Navigator.pop(context); // Zamknij alert
                                    },
                                    buttonTitle: 'OK',
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                      } catch (error) {
                        // Brak maila, pokaż CustomPopup z odpowiednim komunikatem
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const CustomPopup(
                                message: 'Brak maila w bazie danych.',
                                iconData: Icons.error,
                                backgroundColor: Colors.red,
                              ),
                              actions: [
                                BigRedButton(
                                  onTap: () {
                                    Navigator.pop(context); // Zamknij alert
                                  },
                                  buttonTitle: 'OK',
                                ),
                              ],
                            );
                          },
                        );
                      }

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Sukces',
                              style: TextStyle(fontSize: 60),
                            ),
                            content: Column(
                              children: [
                                kBigGap,
                                kBigGap,
                                const Text(
                                  'Na twój e-mail został wysłany token resetujący hasło.',
                                  style: TextStyle(fontSize: 18),
                                ),
                                kBigGap,
                                kBigGap,
                                TextFormField(
                                  controller: tokenController,
                                  decoration:
                                      const InputDecoration(labelText: 'Token'),
                                ),
                                kBigGap,
                                kBigGap,
                                kBigGap,
                                const Text(
                                  'Po kliknięciu przycisku "Potwierdź" wpisany \nToken stanie się Twoim nowym hasłem \ni zostaniesz przekierowany na stronę logowania. \n\nW każdej chwili możesz zmienić hasło \nna inne w ustawieniach Twojego konta',
                                  style: TextStyle(fontSize: 18),
                                ),
                                kBigGap,
                                kBigGap,
                                kBigGap,
                                Container(
                                  margin: kSplashInputMargin,
                                  width: kScreenWidth * 0.30,
                                  child: Image.asset(kDragonLogoPath),
                                ),
                              ],
                            ),
                            actions: [
                              BigRedButton(
                                onTap: () async {
                                  try {
                                    print('Przed weryfikacją tokenu');
                                    print('Token: ${tokenController.text}');

                                    // Weryfikacja tokenu za pomocą Supabase
                                    await supabase.auth.verifyOTP(
                                      type: OtpType.recovery,
                                      token: tokenController.text,
                                      email: emailController.text,
                                    );
                                    isTokenInvalid = false;

                                    print('Po weryfikacji tokenu');
                                  } catch (error) {
                                    print('Błąd weryfikacji tokenu: $error');
                                    const Text(
                                      'Token jest nieprawidłowy.',
                                      style: TextStyle(
                                        color: Colors.red, // Customize color
                                      ),
                                    );
                                    return;
                                  }

                                  print('xx');

                                  // Token stał się nowym hasłem użytkownika
                                  final UserResponse res =
                                      await supabase.auth.updateUser(
                                    UserAttributes(
                                      password: tokenController.text,
                                    ),
                                  );
                                  final User? updatedUser = res.user;
                                  print('yy');

                                  // Zamknięcie dialogu
                                  Navigator.pop(context);
                                  // Nawigacja do strony logowania
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                },
                                buttonTitle: 'Potwierdź',
                              ),
                            ],
                          );
                        },
                      );
                    } on Exception catch (authError) {
                      print('Nieprawidłowy e-mail: $Exception');
                      isLoggingIn = false;

                      // if (authError.message.contains('not found')) {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: const Text('Błąd '),
                      //         content: const Text(
                      //             'Ten e-mail nie istnieje w bazie.'),
                      //         actions: [
                      //           TextButton(
                      //             onPressed: () {
                      //               Navigator.pop(context);
                      //             },
                      //             child: const Text('OK'),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   );
                      // } else {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: const Text('Błąd logowania'),
                      //         content: Text(
                      //             'Wystąpił błąd podczas logowania: ${authError.message}'),
                      //         actions: [
                      //           TextButton(
                      //             onPressed: () {
                      //               Navigator.pop(context);
                      //             },
                      //             child: const Text('OK'),
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   );
                      // }
                      return;
                    }
                  },
                  buttonTitle: 'Zatwierdź',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
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
        ],
      ),
    );
  }
}
