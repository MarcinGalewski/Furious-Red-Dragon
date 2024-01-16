import 'package:flutter/material.dart';
import 'package:furious_red_dragon/components/buttons.dart';
import 'package:furious_red_dragon/main.dart';

import '../../constants.dart';

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({super.key});

  static const routeName = '/addRoom';

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {

  List<String> buildings = ['database failed'];

  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<void> readData() async {
    var response = await supabase
        .from('buildings')
        .select('number');
    setState(() {
      buildings = response;
    });
  }

  String selectedBuilding = '';
  String selectedFloor = '';
  String selectedRoom = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPageBackgroundColor,
        appBar: AppBar(
          backgroundColor: kFuriousRedColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Wybierz salę',
                style: kGlobalTextStyle.copyWith(fontSize: 28)),
            kBigGap,
            Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                  // margin: const EdgeInsets.fromLTRB(0, 20, 0, 60),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Budynek:',
                      style: kGlobalTextStyle.copyWith(fontSize: 18),
                    ),
                    kBigGap,
                    DropdownMenu(
                      textStyle: kGlobalTextStyle,
                      initialSelection: selectedBuilding,
                      onSelected: (newValue) {
                        setState(() {
                          selectedBuilding = newValue ?? selectedBuilding;
                        });
                      },
                      dropdownMenuEntries: buildings
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value,
                            style: const ButtonStyle(
                                textStyle:MaterialStatePropertyAll<TextStyle>(kGlobalTextStyle)
                            ));
                      }).toList(),
                      menuStyle: const MenuStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            kPageBackgroundColor),
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                        filled: true,
                        fillColor: kPageBackgroundColor,
                      ),
                    ),
                  ]),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                  // margin: const EdgeInsets.fromLTRB(0, 20, 0, 60),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Piętro:',
                        style: kGlobalTextStyle.copyWith(fontSize: 18)),
                    kBigGap,
                    DropdownMenu(
                      textStyle: kGlobalTextStyle,
                      enabled: (selectedBuilding!=''),
                      initialSelection: selectedFloor,
                      onSelected: (newValue) {
                        setState(() {
                          selectedFloor = newValue ?? selectedFloor;
                        });
                      },
                      dropdownMenuEntries: buildings
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                        style: const ButtonStyle(
                          textStyle:MaterialStatePropertyAll<TextStyle>(kGlobalTextStyle)
                        ));
                      }).toList(),
                      menuStyle: const MenuStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            kPageBackgroundColor),
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                        filled: true,
                        fillColor: kPageBackgroundColor,
                      ),
                    ),
                  ]),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                  // margin: const EdgeInsets.fromLTRB(0, 20, 0, 60),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sala:',
                        style: kGlobalTextStyle.copyWith(fontSize: 18)),
                    kBigGap,
                    DropdownMenu(
                      textStyle: kGlobalTextStyle,
                      enabled: (selectedFloor!=''),
                      initialSelection: selectedRoom,
                      onSelected: (newValue) {
                        setState(() {
                          selectedRoom = newValue ?? selectedRoom;
                        });
                      },
                      dropdownMenuEntries: buildings
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value,
                            style: const ButtonStyle(
                                textStyle:MaterialStatePropertyAll<TextStyle>(kGlobalTextStyle)
                            ));
                      }).toList(),
                      menuStyle: const MenuStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            kPageBackgroundColor),
                      ),
                      inputDecorationTheme: const InputDecorationTheme(
                        filled: true,
                        fillColor: kPageBackgroundColor,
                      ),
                    ),
                  ]),
            ),
            kBigGap,
            BigWhiteButton(
              onTap: () {},
              buttonTitle: 'Rozpocznij skanowanie',
            )
          ],
        ));
  }
}
