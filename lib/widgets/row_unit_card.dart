import 'package:cashier/widgets/single_unit.dart';
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
            SingleUnit(text: quantity, width: 50),
            SingleUnit(text: price, width: 115),
            SingleUnit(text: name, width: 120),
            SingleUnit(text: id, width: 50),
          ],
        ),
      ),
    );
  }
}

