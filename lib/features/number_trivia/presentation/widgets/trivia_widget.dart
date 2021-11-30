import 'package:flutter/material.dart';
import 'package:numtrivia/features/number_trivia/domain/entities/number_trivia.dart';

class TriviaWidget extends StatelessWidget {
  const TriviaWidget({Key? key, required this.trivia}) : super(key: key);
  final NumberTrivia trivia;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(children: [
          Text(
            trivia.number.toString(),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Expanded(
              child: Center(
                  child: SingleChildScrollView(
            child: Text(
              trivia.text,
              style: const TextStyle(fontSize: 28),
              textAlign: TextAlign.center,
            ),
          )))
        ]));
  }
}
