import 'package:cashier/screens/screens.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTabBar(
        title: 'المخزن',
        firstHeadLine: 'النواقص',
        secondHeadLine: 'جرد الأصناف',
        controller: controller,
      ),
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: 'إضافة صنف جديد',
        onPressed: () {
          Get.to(() => AddProductScreen());
        },
      ),
      body: TabBarView(
        controller: controller,
        children: [
          ProductsScreen(
            isFull: false,
          ),
          ProductsScreen(
            isFull: true,
          ),
        ],
      ),
    );
  }
}
