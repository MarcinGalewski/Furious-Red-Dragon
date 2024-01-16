import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../pages/no_internet.dart';

class InternetController extends GetxController {
  final InternetConnection _connection = InternetConnection();
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  late BuildContext? _context;
  late BuildContext context;

  @override
  void onInit() {
    super.onInit();
    _connection.onStatusChange.listen(_updateInternetStatus);
  }

  static Route<void> _myRouteBuilder(BuildContext context, Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) =>
      const NoInternetDialog(),
    );
  }

  void _updateInternetStatus(InternetStatus internetStatus) {
    switch (internetStatus) {
      case InternetStatus.connected:
        _context = Get.context;
        if (_context != null) {
          context = _context as BuildContext;
          Navigator.pop(context);
        }
        break;
      case InternetStatus.disconnected:

        _context = Get.context;
        if (_context != null) {
          context = _context as BuildContext;
          Navigator.pushNamed(
            context,
            NoInternetDialog.routeName,
          );
        }
        break;
    }
  }
}
