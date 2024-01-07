import 'package:flutter/material.dart';
import 'package:furious_red_dragon/components/buttons.dart';
import 'add_room.dart';
import '../../constants.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kPageBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigWhiteButton(
            onTap: () {
              Navigator.pushNamed(context, AddRoomPage.routeName);
            },
            buttonTitle: 'Dodaj salę',
          ),
        ],
      ),
    );
  }
}
