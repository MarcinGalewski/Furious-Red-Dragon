import 'package:flutter/material.dart';
import 'package:furious_red_dragon/components/buttons.dart';
import 'package:furious_red_dragon/components/white_card.dart';
import '../../constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum View { history, database, details }

int selectedRoomId = 0;

final _supabase = Supabase.instance.client;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  View selectedView = View.history;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kPageBackgroundColor,
      child: FutureBuilder<String>(
        future: getUserRole(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: DoubleButton(
                  onFirstOptionChosen: () {
                    setState(() {
                      selectedView = View.history;
                    });
                  },
                  onSecondOptionChosen: () {
                    setState(() {
                      selectedView = View.database;
                    });
                  },
                  leftOptionLabel: 'Historia',
                  rightOptionLabel: 'Baza danych',
                ),
              ),
              if (selectedView == View.history)
                const Expanded(
                  child: WhiteCard(
                    child: ReportsStream(),
                  ),
                )
              else if (selectedView == View.database)
                if (snapshot.data == 'admin')
                  const AdminDatabaseMenu()
                else
                  const Expanded(
                    child: WhiteCard(
                      child: RoomsStream(),
                    ),
                  )
            ],
          );
        },
      ),
    );
  }
}

class ReportsStream extends StatefulWidget {
  const ReportsStream({super.key});

  @override
  State<ReportsStream> createState() => _ReportsStreamState();
}

class _ReportsStreamState extends State<ReportsStream> {
  final _stream = _supabase.from('reports').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: kFuriousRedColor,
                backgroundColor: kLightGrey,
              ),
            );
          }
          final reports = snapshot.data;
          List<BasicListItem> reportListItems = [];
          for (var report in reports!) {
            final room = report['room'];
            final author = report['author'];
            final reportString = room + ', ' + author;
            reportListItems.add(BasicListItem(
              onTap: () {},
              buttonTitle: reportString,
            ));
          }
          return ListView(
            children: reportListItems,
          );
        });
  }
}

class RoomsStream extends StatefulWidget {
  const RoomsStream({super.key});

  @override
  State<RoomsStream> createState() => _RoomsStreamState();
}

class _RoomsStreamState extends State<RoomsStream> {
  final _stream = _supabase.from('rooms').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: kFuriousRedColor,
                backgroundColor: kLightGrey,
              ),
            );
          }
          final rooms = snapshot.data;
          List<BasicListItem> reportListItems = [];
          for (var room in rooms!) {
            final name = room['name'];
            final building = room['id_building'];
            final floor = room['floor'];
            final roomString = 'Sala $floor/$name p.$floor, bud. $building';
            reportListItems.add(BasicListItem(
              onTap: () {
                selectedRoomId = room['id'];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RoomDetailsScreen()));
              },
              buttonTitle: roomString,
            ));
          }
          return ListView(
            children: reportListItems,
          );
        });
  }
}

class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const WhiteCard(
        child: ItemsStream(),
      ),
    );
  }
}

class ItemsStream extends StatefulWidget {
  const ItemsStream({super.key});

  @override
  State<ItemsStream> createState() => _ItemsStreamState();
}

class _ItemsStreamState extends State<ItemsStream> {
  final _stream = _supabase
      .from('items')
      .stream(primaryKey: ['id']).eq('id_room', selectedRoomId);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: kFuriousRedColor,
                backgroundColor: kLightGrey,
              ),
            );
          }
          final items = snapshot.data;
          List<BasicListItem> itemsListItems = [];
          for (var item in items!) {
            final type = item['type'];
            final brand = item['brand'];
            final reportString = type + ' ' + brand;
            itemsListItems.add(BasicListItem(
              onTap: () {},
              buttonTitle: reportString,
            ));
          }
          return ListView(
            children: itemsListItems,
          );
        });
  }
}

class UsersStream extends StatefulWidget {
  const UsersStream({super.key});

  @override
  State<UsersStream> createState() => _UsersStreamState();
}

class _UsersStreamState extends State<UsersStream> {
  final _stream = _supabase.from('roles').stream(primaryKey: ['id']);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: kFuriousRedColor,
                backgroundColor: kLightGrey,
              ),
            );
          }
          final users = snapshot.data;
          List<BasicListItem> itemsListItems = [];
          for (var user in users!) {
            final name = user['name'];
            final status = user['status'];
            final email = user['email'];
            final userString = name + ' ' + status + ' ' + email;
            itemsListItems.add(BasicListItem(
              onTap: () {},
              buttonTitle: userString,
            ));
          }
          return Expanded(
            child: ListView(
              children: itemsListItems,
            ),
          );
        });
  }
}

Future<String> getUserRole() async {
  var response = await _supabase
      .from('roles')
      .select('status')
      .eq('user_id', _supabase.auth.currentUser?.id)
      .single();

  return response['status'] as String;
}

class AdminDatabaseMenu extends StatefulWidget {
  const AdminDatabaseMenu({super.key});

  @override
  State<AdminDatabaseMenu> createState() => _AdminDatabaseMenuState();
}

class _AdminDatabaseMenuState extends State<AdminDatabaseMenu> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: WhiteCard(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Wybierz bazę',
                style: TextStyle(fontSize: 20),
              ),
              kBigGap,
              SizedBox(
                width: kScreenWidth,
                child: BigWhiteButton(
                  buttonTitle: 'Lokalizacje',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RoomsScreen()));
                  },
                ),
              ),
              kBigGap,
              SizedBox(
                  width: kScreenWidth,
                  child: BigWhiteButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UsersScreen()));
                      },
                      buttonTitle: 'Użytkownicy')),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const WhiteCard(
        child: RoomsStream(),
      ),
    );
  }
}

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WhiteCard(
        child: Column(
          children: [
            const UsersStream(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddUserScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Column(children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                  ),
                  Text(
                    'Dodaj',
                    style: TextStyle(color: Colors.black),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj użytkownika'),
      ),
      body: WhiteCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 40,
                  child: Text('Imię:'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffF3F3F3)),
                      child: TextField(
                        decoration: InputDecoration(
                          labelStyle: kGlobalTextStyle.copyWith(
                            color: const Color.fromRGBO(177, 170, 170, 1),
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        style: kGlobalTextStyle.copyWith(
                          color: const Color.fromARGB(255, 2, 2, 2),
                          fontSize: 18,
                        ),
                        cursorColor: kFuriousRedColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            kSmallGap,
            Row(
              children: [
                const SizedBox(width: 40, child: Text('Email:')),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffF3F3F3)),
                      child: TextField(
                        decoration: InputDecoration(
                          labelStyle: kGlobalTextStyle.copyWith(
                            color: const Color.fromRGBO(177, 170, 170, 1),
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        style: kGlobalTextStyle.copyWith(
                          color: const Color.fromARGB(255, 2, 2, 2),
                          fontSize: 18,
                        ),
                        cursorColor: kFuriousRedColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            kSmallGap,
            SmallButton(onTap: () {}, buttonTitle: 'Dodaj')
          ],
        ),
      ),
    );
  }
}
