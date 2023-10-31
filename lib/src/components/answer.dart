import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function()? handleAnswerChoice;

  const Answer(
      {required this.text,
      this.isSelected = false,
      this.handleAnswerChoice,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: handleAnswerChoice,
                style: TextButton.styleFrom(
                  shape: const BeveledRectangleBorder(), // borda pontuda
                  backgroundColor:
                      isSelected ? Colors.blue : Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  side: const BorderSide(
                    color: Colors.blue,
                    width: .5,
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
