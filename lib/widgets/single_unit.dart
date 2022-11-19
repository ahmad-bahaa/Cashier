import 'package:flutter/material.dart';

class SingleUnit extends StatelessWidget {
  const SingleUnit({
    Key? key,
    required this.text,
    required this.width,
    required this.isBold,
  }) : super(key: key);

  final String text;
  final double width;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: isBold ? FontWeight.bold : null,
        ),
        textDirection: TextDirection.rtl,
        maxLines: 1,
      ),
    );
  }
}
