import 'package:flutter/material.dart';
import '../constants.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget(
      {Key? key,
      required this.indexAction,
      required this.question,
      required this.totalQuestions})
      : super(key: key);

  final int indexAction;
  final String question;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        'Question ${indexAction + 1}/$totalQuestions:$question',
        style: const TextStyle(fontSize: 24, color: neutral),
      ),
    );
  }
}
