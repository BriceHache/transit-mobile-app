import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Divider(
        indent: 10,
        endIndent: 10,
        thickness: 2,
        color: Colors.white,
        height: 26,
      ),
    );
  }
}
