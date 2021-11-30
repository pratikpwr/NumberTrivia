import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Center(
            child: SingleChildScrollView(
          child: Text(
            title,
            style: const TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
        )));
  }
}
