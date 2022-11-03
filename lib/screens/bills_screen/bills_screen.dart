import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/models/bill_model.dart';
import 'package:cashier/screens/screens.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillsScreen extends StatelessWidget {
  BillsScreen({Key? key, required this.isCelling}) : super(key: key);
  final BillController billController = Get.put(BillController());
  final bool isCelling;

  @override
  Widget build(BuildContext context) {
    String buttonText =
        isCelling ? 'إضافة فاتورة مبيعات' : 'إضافة فاتورة مشتريات';
    String title = isCelling ? 'مبيعات' : 'مشتريات';
    List<Bill> bills =
        isCelling ? billController.ongoingBills : billController.incomingBills;
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
      ),
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: buttonText,
        onPressed: () {
          Get.to(() => AddBillScreen(
                isCelling: isCelling,
              ));
        },
      ),
      body: Obx(
        () => ListView.builder(
            shrinkWrap: true,
            itemCount: bills.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  //TODO: View Bill details
                  Get.to(() => BillScreen(isCelling: isCelling,bill:bills[index]));
                },
                child: buildBillReportRow(
                  bills[index],
                ),
              );
            }),
      ),
    );
  }

  CustomContainer buildBillReportRow(Bill bill) {
    return CustomContainer(
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    //TODO: this should be total Bill Cost
                    bill.price.toString(),
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  // Text(
                  //   ' صنف ${bill.products.length.toString()}  ',
                  //   style: const TextStyle(fontSize: 16, color: Colors.black),
                  // ),
                ],
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
