import 'package:cashier/controllers/cash_controller.dart';
import 'package:cashier/models/cash_model.dart';
import 'package:cashier/screens/cash_screens/add_cash_screen.dart';
import 'package:cashier/widgets/custom_bottom_app_bar.dart';
import 'package:cashier/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashReportScreen extends StatelessWidget {
  CashReportScreen({Key? key, required this.cashType}) : super(key: key);
  final bool cashType;

  CashController cashController = Get.put(CashController());

  @override
  Widget build(BuildContext context) {
    String text = cashType ? 'دفع نقدية جديدة' : 'استلام نقدية جديدة';

    Color color = cashType ? Colors.red : Colors.green;
    List<Cash> cash =
        cashType ? cashController.allSending : cashController.allReceiving;

    return Scaffold(
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: text,
        onPressed: () {
          Get.to(() => AddCashScreen(
                isSending: cashType,
              ));
        },
      ),
      body: Obx(
        () => ListView.builder(
            shrinkWrap: true,
            itemCount: cash.length,
            itemBuilder: (context, index) {
              return InkWell(
                  // onTap: () => Get.to(() => AddCashScreen(
                  //       cash: cash[index],
                  //       isSending: cashType,
                  //     )),
                  child: buildCashReportRow(cash[index], color));
            }),
      ),
    );
  }

  CustomContainer buildCashReportRow(Cash cash, Color color) {
    return CustomContainer(
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cash.money.toString(),
                style: TextStyle(fontSize: 24, color: color),
              ),
              Column(
                children: [
                  Text(
                    cash.name,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    cash.date.toString(),
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
