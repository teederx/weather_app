import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class FormatText extends StatelessWidget {
  const FormatText({super.key, required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: const TextStyle(fontSize: 24),
      textAlign: TextAlign.center,
    );
  }
}
