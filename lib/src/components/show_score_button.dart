import "package:flutter/material.dart";

class ShowScoreButton extends StatelessWidget {
  final void Function()? onPressed;

  const ShowScoreButton({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.green,
        backgroundColor: Colors.green.shade100,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Text(
            'ver pontuação ',
          ),
          Icon(
            Icons.arrow_forward,
            size: 15,
          )
        ],
      ),
    );
  }
}
