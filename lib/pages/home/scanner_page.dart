import 'package:flutter/material.dart';

import '../../styles.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: pageBackgroundColor,
        child: ListView(
          children: const [Text('Skanuj')],
        ));
  }
}
