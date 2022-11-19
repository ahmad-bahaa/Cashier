import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/widgets/single_unit.dart';
import 'package:flutter/material.dart';

class RowBillCard extends StatelessWidget {
  const RowBillCard({
    Key? key,
    required this.product,
    required this.i,
    required this.isCelling,
  }) : super(key: key);

  final Product product;
  final int i;
  final bool isCelling;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: isCelling
                ? product.cellPrice < product.buyPrice
                    ? Colors.red[100]
                    : Colors.transparent
                : Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SingleUnit(text: i.toString(), width: 25,isBold: false,),
                SingleUnit(text: product.name.toString(), width: 120,isBold: false,),
                SingleUnit(text: product.quantity.toString(), width: 40,isBold: false,),
                SingleUnit(text: product.cellPrice.toString(), width: 50,isBold: false,),
                SingleUnit(
                    text: '${product.cellPrice * product.quantity}', width: 55,isBold: true,),
              ],
            ),
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
