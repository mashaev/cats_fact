import 'package:flutter/material.dart';

class FactCard extends StatelessWidget {
  final String? text;

  const FactCard({Key? key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: TextStyle(
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
