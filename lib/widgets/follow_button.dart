import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final String buttonText;
  final Color textColor;
  const FollowButton({
    Key? key,
    this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    required this.buttonText,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: TextButton(
          onPressed: onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.center,
            width: 250,
            height: 27,
            child: Text(
              buttonText,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
