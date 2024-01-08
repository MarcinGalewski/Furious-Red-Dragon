import 'package:flutter/material.dart';
import 'package:furious_red_dragon/constants.dart';

class NoCamera extends StatelessWidget {
  const NoCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 45,
        vertical: 30,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: kLightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              size: 100,
              color: Colors.black,
            ),
            kMediumGap,
            Text(
              'Nie wykryto aparatu',
              style: kGlobalTextStyle.copyWith(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )),
      ),
    );
  }
}
