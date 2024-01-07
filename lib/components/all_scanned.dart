import 'package:flutter/material.dart';
import 'package:furious_red_dragon/constants.dart';
import 'package:furious_red_dragon/components/buttons.dart';

class AllScanned extends StatelessWidget {
  // Adding named parameter 'key' to the constructor
  const AllScanned({Key? key, required this.message}) : super(key: key);

  final String message;
  final Color backgroundColor = kGoodGreenColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      duration: const Duration(seconds: 15),
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 500,
              minHeight: 600,
            ),
            child: Material(
              elevation: 24,
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          // Ustawienie kształtu kontenera na okrągły
                          color: Color.fromARGB(255, 0, 0, 0)
                          // Możesz zmienić na dowolny kolor lub ustawić transparentny
                          ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 200,
                        color: kGoodGreenColor,
                      ),
                    ),
                    kBigGap,
                    kBigGap,
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 24,
                        // fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    kBigGap,
                    kBigGap,
                    BigWhiteButton(
                      onTap: () {},
                      buttonTitle: ('Przejdź do podsumowania'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
