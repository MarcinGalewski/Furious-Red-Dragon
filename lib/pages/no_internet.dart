import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../constants.dart';


class NoInternetDialog extends StatefulWidget {
  const NoInternetDialog({super.key});

  @override
  State<NoInternetDialog> createState() => _NoInternetDialogState();

  static const routeName = '/NoInternetDialog';
}

class _NoInternetDialogState extends State<NoInternetDialog> {
  late StreamSubscription subscription;
  bool firstRun = true;

  @override
  void initState() {
    super.initState();
    getConnectivity();
  }


  getConnectivity() {
    subscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
          switch (status) {
            case InternetStatus.connected:
              if (firstRun) {
                firstRun = false;
              } else {
                Navigator.pop(context);
              }
              break;
            case InternetStatus.disconnected:
              firstRun = false;
              Navigator.pushNamed(
                context, NoInternetDialog.routeName);
              break;
          }
        });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  static const IconData wifi_off = IconData(0xe6eb, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        backgroundColor: kFuriousRedColor
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: kSplashInputMargin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: kSplashInputMargin,
              child: Icon(wifi_off, size: kScreenWidth * 0.5)
              ),
            Container(
              color: Colors.white,
              child: Text(
                'Bez internetu nie damy rady!',
                textAlign: TextAlign.center,
                style: kGlobalTextStyle.copyWith(
                  fontSize: 26,
                  // height: 1.75,
                  fontWeight: FontWeight.w800
                ),
              ),
            ),
            kBigGap,
            Container(
              color: Colors.white,
              child: Text(
                'Połącz się z siecią, aby korzystać z aplikacji',
                textAlign: TextAlign.center,
                style: kGlobalTextStyle.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600
                  // height: 1.75,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}