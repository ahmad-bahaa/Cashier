import 'package:cashier/screens/screens.dart';
import 'package:cashier/widgets/custom_app_bar.dart';
import 'package:cashier/widgets/custom_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'المبيعات',),
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: 'إضافة فاتورة مبيعات',
        onPressed: () {
          Get.to(() => AddBillScreen());
        },
      ),
    );
  }
}
