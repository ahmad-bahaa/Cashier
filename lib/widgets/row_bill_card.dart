import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/widgets/single_unit.dart';
import 'package:flutter/material.dart';

class RowBillCard extends StatelessWidget {
  const RowBillCard(
      {Key? key,
      required this.product,
      required this.i,
      required this.billController})
      : super(key: key);

  final Product product;
  final int i;
  final BillController billController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleUnit(text: i.toString(), width: 50),
              const VerticalDivider(
                thickness: 1,
              ),
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
