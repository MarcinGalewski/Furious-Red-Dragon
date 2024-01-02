import 'package:flutter/material.dart';
import 'package:furious_red_dragon/main.dart';
import 'package:gap/gap.dart';

const kFuriousRedColor = Color.fromRGBO(193, 39, 38, 1);
const kPageBackgroundColor = Color.fromRGBO(243, 243, 243, 1);
const kLightGrey = Color.fromRGBO(217, 217, 217, 1);
const kDarkerGrey = Color.fromRGBO(177, 170, 170, 1);
const kGoodGreenColor = Color.fromRGBO(132, 228, 109, 1);

final kGlobalContext = MyApp.navigatorKey.currentContext;
final kScreenWidth = MediaQuery.of(kGlobalContext!).size.width;

EdgeInsets kSplashInputMargin =
    EdgeInsets.symmetric(horizontal: 0.12 * kScreenWidth);

const TextStyle kGlobalTextStyle =
    TextStyle(fontFamily: 'Lato', letterSpacing: 0.41);

const kButtonElevation = 2.0;

/// Creates a gap that has 10px.
const Widget kSmallGap = Gap(10);

/// Creates a gap that has 15px.
const Widget kMediumGap = Gap(15);

/// Creates a gap that has 20px.
const Widget kBigGap = Gap(20);

const kDragonLogoPath = 'assets/images/dragon.png';


