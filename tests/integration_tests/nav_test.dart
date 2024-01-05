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
  if (supabase.auth.currentUser != null) {
    supabase.auth.signOut();
  }

  group('Testing App', () {
    testWidgets('Navigation Test', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Zaloguj się'), findsOneWidget);
      await tester.tap(find.text('Zaloguj się'));
      await tester.pumpAndSettle();

      expect(find.byType(CustomTextField), findsAtLeast(2));
      expect(find.text('Email'), findsOne);
      expect(find.text('Hasło'), findsOne);

      final email = find.widgetWithText(TextFormField, 'Email');
      final password = find.widgetWithText(TextFormField, 'Hasło');

      //await tester.tap(find.text('Email'));
      const falseEmail = 'testt@gmail.com';
      const falsePass = '333';

      await tester.enterText(email, falseEmail);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(seconds: 2));

      await tester.enterText(password, falsePass);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.text('Zaloguj się'));
      await tester.pump(const Duration(seconds: 7));

      expect(find.text('OK'), findsOne);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      final emailN = find.widgetWithText(TextFormField, falseEmail);
      final passwordN = find.widgetWithText(TextFormField, falsePass);

      await tester.enterText(emailN, 'tester@gmail.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.text('tester@gmail.com'), findsOne);

      await tester.enterText(passwordN, '123');
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.text('Zaloguj się'));
      await tester.pump(const Duration(seconds: 5));

      expect(find.text('Witaj, imię'), findsOne);

      await tester.tap(find.text('Konto'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Dodaj salę'), findsOneWidget);

      await tester.tap(find.text('Historia'));
      await tester.pump(const Duration(seconds: 8));

      //expect(find.text('3/21, Szef'), findsOne);

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

      expect(find.text('krzesło krzesło'), findsOne);
      expect(find.text('komputer dell'), findsOne);

      expect(find.byType(BackButton), findsOne);
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

      final wyloguj = find.text('Wyloguj');
      expect(wyloguj, findsOne);
      await tester.tap(wyloguj);

      await tester.pump(const Duration(seconds: 4));
      expect(find.text('Zaloguj się'), findsOne);

      //expect(find.text('OK'), findsOne);
      //await tester.tap(find.text('OK'));

      //await tester.enterText(find.text('Hasło'), 'test123');
      //tester.pumpAndSettle();
      //await tester.tap(find.text('Zaloguj się'));
      //await tester.pumpAndSettle();
    });
  });
}
