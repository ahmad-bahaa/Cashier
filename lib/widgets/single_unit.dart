import 'package:flutter/material.dart';

class SingleUnit extends StatelessWidget {
  const SingleUnit({Key? key, required this.text, required this.width})
      : super(key: key);

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
        ),
        textDirection: TextDirection.rtl,
        maxLines: 1,
      ),
    );
  }
}
