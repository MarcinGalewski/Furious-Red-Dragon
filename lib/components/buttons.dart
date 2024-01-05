import 'package:flutter/material.dart';
import 'package:furious_red_dragon/constants.dart';

class BigRedButton extends StatelessWidget {
  const BigRedButton({
    super.key,
    required this.onTap,
    required this.buttonTitle,
  });

  final Function onTap;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ]),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kFuriousRedColor,
          maximumSize: const Size(300, 100),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onPressed: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            buttonTitle,
            style: kGlobalTextStyle.copyWith(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class BigWhiteButton extends StatelessWidget {
  const BigWhiteButton({
    super.key,
    required this.onTap,
    required this.buttonTitle,
    this.borderColor = Colors.black,
  });
  final Function onTap;
  final String buttonTitle;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ]),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            maximumSize: const Size(300, 100),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: borderColor)),
          ),
          onPressed: () => onTap(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(buttonTitle,
                style: kGlobalTextStyle.copyWith(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ));
  }
}

class SmallButton extends StatelessWidget {
  const SmallButton(
      {super.key,
      this.backgroundColor = kDarkerGrey,
      this.textColor = Colors.black,
      required this.onTap,
      required this.buttonTitle});

  final Function onTap;
  final String buttonTitle;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          )),
      onPressed: () => onTap(),
      child: Text(
        buttonTitle,
        textAlign: TextAlign.center,
        style: kGlobalTextStyle.copyWith(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class DoubleButton extends StatefulWidget {
  const DoubleButton(
      {super.key,
      this.activeColor = Colors.white,
      this.inactiveColor = kLightGrey,
      required this.onFirstOptionChosen,
      required this.onSecondOptionChosen,
      required this.leftOptionLabel,
      required this.rightOptionLabel});

  final Color activeColor;
  final Color inactiveColor;
  final Function onFirstOptionChosen;
  final Function onSecondOptionChosen;
  final String leftOptionLabel;
  final String rightOptionLabel;

  @override
  State<DoubleButton> createState() => _DoubleButtonState();
}

class _DoubleButtonState extends State<DoubleButton> {
  int selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: selectedOption == 1 ? 46 : 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOption == 1
                    ? widget.activeColor
                    : widget.inactiveColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              onPressed: () {
                if (selectedOption == 2) {
                  setState(() {
                    selectedOption = 1;
                  });
                  widget.onFirstOptionChosen();
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  widget.leftOptionLabel,
                  style: kGlobalTextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: selectedOption == 2 ? 46 : 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOption == 2
                    ? widget.activeColor
                    : widget.inactiveColor,
                maximumSize: const Size(300, 100),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              onPressed: () {
                if (selectedOption == 1) {
                  setState(() {
                    selectedOption = 2;
                  });
                  widget.onSecondOptionChosen();
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  widget.rightOptionLabel,
                  style: kGlobalTextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ForgotPasswordText extends StatelessWidget {
  const ForgotPasswordText({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerRight, // Wyśrodkuj tekst do prawej
        padding: const EdgeInsets.symmetric(horizontal: 50).copyWith(bottom: 8),
        child: Text(
          'Zapomniałeś/aś hasła?',
          style: kGlobalTextStyle.copyWith(
            color: kDarkerGrey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Lato',
          ),
        ),
      ),
    );
  }
}

class BasicListItem extends StatelessWidget {
  const BasicListItem({
    super.key,
    required this.onTap,
    required this.buttonTitle,
    this.borderColor = Colors.black,
  });
  final Function onTap;
  final String buttonTitle;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.white,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: borderColor)),
          ),
          onPressed: () => onTap(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(buttonTitle,
                  textAlign: TextAlign.left,
                  style: kGlobalTextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
        ));
  }
}