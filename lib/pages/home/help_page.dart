import 'package:flutter/material.dart';
import '../../constants.dart';

class FAQEntry extends StatefulWidget {
  final String question;
  final String answer;

  const FAQEntry({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  _FAQEntryState createState() => _FAQEntryState();
}

class _FAQEntryState extends State<FAQEntry> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isExpanded ? null : 55, // null height when expanded

      child: Container(
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  widget.question,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              if (isExpanded)
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    widget.answer,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQSection extends StatelessWidget {
  const FAQSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 333,
      height: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListView(
        children: const [
          kSmallGap,
          FAQEntry(
            question: 'Do czego służy Wściekły Czerwony Smok?',
            answer:
                'Aplikacja  służy do  przeprowadzania inwentaryzacji przedmiotów w salach w budynkach na terenie SGGW.',
          ),
          kSmallGap,
          FAQEntry(
              question: 'Czy istnieje wizualny podgląd do budynków i sal?',
              answer:
                  'Aby uzyskać wizualny podgląd do planów budynków i rozmieszczeń sal: Pobierz aplikację Kampus'),
          kSmallGap,
          FAQEntry(
            question: 'Kto może dodawać i usuwać  użytkowników?',
            answer:
                'Tylko osoba z uprawnieniami administratora może dodawać oraz usuwać konta użytkowników.',
          ),
          kSmallGap,
          FAQEntry(
            question: 'Jak mogę zacząć korzystać z aplikacji?',
            answer:
                'Wystarczy pobrać aplikację, następnie zalogować się na wcześniej utworzonym koncie przez administratora  i postępuj zgodnie z instrukcjami dotyczącymi skanowania.',
          ),
          kSmallGap,
          FAQEntry(
            question:
                'Czy aplikacja wspiera funkcję śledzenia historii zmian przedmiotów w salach??',
            answer:
                'Aplikacja pozwala na sprawdzenie historii zmian przedmiotów, które znajdują się w sali, lub tych które z jakiegoś powodu się już w niej nie znajdują. (np. były popsute, lub powinny znajdować się w innej sali)',
          ),
          kSmallGap,
          FAQEntry(
            question:
                'Czy potrzebuję specjalnego sprzętu do korzystania z aplikacji?',
            answer:
                'Do korzystania z aplikacji wystarczy zwykły smartfon lub tablet z systemem Android lub iOS z odpowiednią kamerą.',
          ),
          kSmallGap,
          FAQEntry(
            question:
                'Czy jeżeli posiadam urządzenie z zepsutą kamerą nadal mogę korzystać z urządzenia?',
            answer:
                'Tak, aplikacja pozwala na skanowanie kodów kreskowych, oraz na wpisywanie ich ręcznie.',
          ),
          kSmallGap,
          FAQEntry(
            question: 'Jak często powinienem aktualizować dane w aplikacji?',
            answer:
                'Zależy to od specyfiki zastosowania. Jeśli przedmioty w salach często się zmieniają, regularne aktualizacje mogą być konieczne, aby utrzymać dokładność danych.',
          ),
        ],
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kPageBackgroundColor,
      child: ListView(
        children: const [
          FAQSection(),
        ],
      ),
    );
  }
}
