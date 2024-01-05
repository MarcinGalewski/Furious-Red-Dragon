import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furious_red_dragon/components/input.dart';
import 'package:integration_test/integration_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:furious_red_dragon/main.dart';

void main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  await Supabase.initialize(
    url: 'https://ubjqvkvameebwmsjujbd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVianF2a3ZhbWVlYndtc2p1amJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTkwNjIwNTUsImV4cCI6MjAxNDYzODA1NX0.C0T-L8L_T5ny_gL2Mm4RAQJ36-DtZDoByAbLAqPcymk',
  );
  final client = SupabaseClient('https://ubjqvkvameebwmsjujbd.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVianF2a3ZhbWVlYndtc2p1amJkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5OTA2MjA1NSwiZXhwIjoyMDE0NjM4MDU1fQ.YLPceJ2EnaSBlM_FNeDlRJPp-WMzxySnM5uEgFe4jj0');

  const email = 'user@email.com';
  const password = 'password';
  try {
    final res = await client.auth.admin.createUser(AdminUserAttributes(
        email: email, password: password, emailConfirm: true));
  } on AuthException {}

  if (supabase.auth.currentUser != null) {
    supabase.auth.signOut();
  }
  /*final res = await supabase.auth.admin.createUser(AdminUserAttributes(
      email: 'user@email.com',
      password: 'password',
      userMetadata: {'name': 'Yoda'},
      emailConfirm: true));
  const Duration(seconds: 1);
  */
  group('Testing App', ({var emailG = email, var passwordG = password}) {
    testWidgets('Navigation Test', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Zaloguj się'), findsOneWidget,
          reason: 'Nie odnaleziono zaloguj się');
      await tester.tap(find.text('Zaloguj się'));
      await tester.pumpAndSettle();

      expect(find.byType(CustomTextField), findsAtLeast(2),
          reason: 'Nie odnaleziono dwoch text inputs');
      expect(find.text('Email'), findsOne,
          reason: 'Nie odnaleziono input email');
      expect(find.text('Hasło'), findsOne,
          reason: 'Nie odnaleziono input hasła');

      final email = find.widgetWithText(TextFormField, 'Email');
      final password = find.widgetWithText(TextFormField, 'Hasło');

      //await tester.tap(find.text('Email'));
      const falseEmail = 'testt@gmail.com';
      const falsePass = '333';

      await tester.enterText(email, falseEmail);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      await tester.enterText(password, falsePass);
      await tester.pumpAndSettle();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.text('Zaloguj się'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 7));

      expect(find.text('OK'), findsOne, reason: 'Nie odnaleziono przycisku OK');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      final emailN = find.widgetWithText(TextFormField, falseEmail);
      final passwordN = find.widgetWithText(TextFormField, falsePass);

      //await tester.enterText(emailN, 'tester@gmail.com');
      await tester.enterText(emailN, emailG);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text(emailG), findsOne,
          reason: 'Text nie został wpisany w input email');

      //await tester.enterText(passwordN, '123');
      await tester.enterText(passwordN, passwordG);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.text('Zaloguj się'));
      await tester.pump(const Duration(seconds: 5));

      expect(find.text('Witaj, imię'), findsOne,
          reason: 'Nie odnaleziono tekstu Witaj, imię');

      await tester.tap(find.text('Konto'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Dodaj salę'), findsOneWidget,
          reason: 'Nie odnaleziono dodaj salę');

      await tester.tap(find.text('Historia'));
      await tester.pump(const Duration(seconds: 8));

      expect(find.textContaining('3/21, Szef'), findsOne,
          reason: 'Nie odnaleziono wejścia z szefem');

      await tester.tap(find.text('Baza danych'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Sala 1/7 p.1, bud. 34'), findsOne,
          reason: 'Nie odnaleziono sali 1/7 p1...');
      expect(find.text('Sala 3/33 p.3, bud. 32'), findsOne,
          reason: 'Nie odnaleziono sali 3/33 p3...');
      expect(find.text('Sala 2/12 p.2, bud. 34'), findsOne,
          reason: 'Nie odnaleziono sali 2/12 p2...');

      await tester.tap(find.text('Sala 1/7 p.1, bud. 34'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('krzesło krzesło'), findsOne,
          reason: 'Nie odnaleziono krzesło krzesło');
      expect(find.text('komputer dell'), findsOne,
          reason: 'Nie odnaleziono komputer dell');

      expect(find.byType(BackButton), findsOne,
          reason: 'Nie odnaleziono BackButton');
      await tester.tap(find.byType(BackButton));
      await tester.pump(const Duration(seconds: 2));

      /*await tester.tap(find.text('Skanuj'));
      await tester.pump(const Duration(seconds: 2));
      //expect(find.text('While using the app'), findsOne);
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/permissions/methods'),
          (MethodCall methodCall) async => PermissionStatus.granted);
      

      //await tester.tap(find.text('While using the app'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Wpisz kod ręcznie'), findsExactly(1));

      await tester.tap(find.text('Wpisz kod ręcznie'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.byType(BackButton), findsOne);
      await tester.tap(find.byType(BackButton));
      await tester.pump(const Duration(seconds: 2));
      */

      await tester.tap(find.text('Pomoc'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Do czego służy Wściekły Czerwony Smok?'), findsOne,
          reason: 'Nie odnaleziono do czego służy aplikacja');
      expect(find.text('Czy istnieje wizualny podgląd do budynków i sal?'),
          findsOne,
          reason: 'Nie odnaleziono czy istnieje wizualny podglad');
      expect(find.text('Kto może dodawać nowych użytkowników?'), findsOne,
          reason: 'Nie odnaleziono kto moze dodawać');

      final settings = find.byIcon(Icons.settings);

      await tester.tap(settings);
      await tester.pump(const Duration(seconds: 2));

      final usun = find.textContaining('Usuń');
      expect(usun, findsOne, reason: 'Nie odnaleziono przycisku Usuń');
      await tester.tap(usun);
      await tester.pump(const Duration(seconds: 4));

      expect(find.textContaining('Tak'), findsExactly(1),
          reason: 'Nie odnaleziono przycisku Tak po kliknięciu Usuń');
      expect(find.textContaining('Nie'), findsExactly(1),
          reason: 'Nie odnaleziono przycisku Nie po kliknięciu Usuń');

      await tester.tap(find.textContaining('Tak'));
      await tester.pump(const Duration(seconds: 7));
      expect(find.text('Zaloguj się'), findsOne,
          reason:
              'Nie odnaleziono przycisku zaloguj, najpewniej usuowanie nie zostalo jeszcze zrealizowane');

      await tester.tap(find.text('Zaloguj się'));
      await tester.pumpAndSettle();
      await tester.enterText(email, emailG);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.enterText(password, passwordG);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Zaloguj się'));
      await tester.pump(const Duration(seconds: 5));
      expect(find.textContaining('Invalid'), findsOne,
          reason: 'Uzytkownik nie zostal usuniety');

      //expect(find.text('OK'), findsOne);
      //await tester.tap(find.text('OK'));

      //await tester.enterText(find.text('Hasło'), 'test123');
      //tester.pumpAndSettle();
      //await tester.tap(find.text('Zaloguj się'));
      //await tester.pumpAndSettle();
    });
  });
}
