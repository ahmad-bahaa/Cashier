import 'package:cashier/models/product_model.dart';
import 'package:cashier/widgets/single_unit.dart';
import 'package:flutter/material.dart';

class RowBillCard extends StatelessWidget {
  const RowBillCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleUnit(text: product.id.toString(), width: 50),
              SingleUnit(text: product.name.toString(), width: 110),
              SingleUnit(text: product.quantity.toString(), width: 50),
              SingleUnit(text: product.cellPrice.toString(), width: 50),
              SingleUnit(text: product.buyPrice.toString(), width: 50),
            ],
          ),
        ),
        const Divider(
          thickness: 1.0,
          color: Colors.black,
        ),
      ],
    );
  }
}