import 'package:furious_red_dragon/controller/internet_controller.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class DependencyInjection {

  static void init() {
    Get.put<InternetController>(InternetController(),permanent:true);
  }
}