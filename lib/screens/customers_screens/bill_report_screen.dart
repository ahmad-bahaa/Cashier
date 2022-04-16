import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/models/bill_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillReportScreen extends StatelessWidget {
  BillReportScreen({Key? key}) : super(key: key);

  final DataBaseServices dataBaseServices = DataBaseServices();
  final BillController billController = Get.put(BillController());
  List<Bill> bills = <Bill>[];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          return InkWell(child: buildBillReportRow(bills[index]));
        });
  }

  CustomContainer buildBillReportRow(Bill bill) {
    return CustomContainer(
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                //TODO: this should be total Bill Cost
                bill.price.toString(),
                style: const TextStyle(fontSize: 24, color: Colors.green),
              ),
              Column(
                children: [
                  Text(
                    bill.name,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    bill.date.toString(),
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              )
            ],
          ),
        ),
        color: Colors.white);
  }
}
