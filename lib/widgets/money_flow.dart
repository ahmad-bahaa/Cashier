import 'package:flutter/material.dart';

class MoneyFlow extends StatelessWidget {
  const MoneyFlow(
      {Key? key, required this.cash, required this.type, required this.color})
      : super(key: key);
  final String cash, type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        margin: const EdgeInsets.only(right: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                cash,
                style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold, color: color),
              ),
            ),
            Text(
              type,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
