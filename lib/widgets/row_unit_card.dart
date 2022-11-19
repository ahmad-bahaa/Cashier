import 'package:cashier/widgets/single_unit.dart';
import 'package:flutter/material.dart';

class RowUnitCard extends StatelessWidget {
  const RowUnitCard(
      {Key? key,
      required this.name,
      required this.quantity,
      required this.color})
      : super(key: key);
  final String name;
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
            SingleUnit(text: quantity, width: 80,isBold: false,),
            SingleUnit(text: name, width: 150,isBold: false,),
          ],
        ),
      ),
    );
  }
}

