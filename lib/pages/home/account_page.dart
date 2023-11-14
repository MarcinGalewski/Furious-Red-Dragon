import 'package:flutter/material.dart';
import 'package:furious_red_dragon/components/buttons.dart';
import 'add_room.dart';
import '../../constants.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPageBackgroundColor,
        body: Center(
            child: BigWhiteButton(
              onTap: () {
              Navigator.pushNamed(context, AddRoomPage.routeName);
            },
            buttonTitle: 'Dodaj salę',
        )
      )
    );
  }
// Było jak poniżej, przerobiłem trochę całość by sensownie umieścić przycisk

/*  @override
  Widget build(BuildContext context) {
    return Material(
        color: kPageBackgroundColor,
        child: ListView(
          children: const [Text('Konto')],
        )
    );
  }*/




}
