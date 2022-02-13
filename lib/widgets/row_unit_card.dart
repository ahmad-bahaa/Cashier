import 'package:flutter/material.dart';

class RowUnitCard extends StatelessWidget {
  const RowUnitCard(
      {Key? key,
      required this.id,
      required this.name,
      required this.price,
      required this.quantity,
      required this.color})
      : super(key: key);
  final String id;
  final String name;
  final String price;
  final String quantity;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            singleUnit(text: quantity, width: 50),
            singleUnit(text: price, width: 115),
            singleUnit(text: name, width: 120),
            singleUnit(text: id, width: 50),
          ],
        ),
      ),
    );
  }
}

class singleUnit extends StatelessWidget {
  const singleUnit({Key? key, required this.text, required this.width})
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
