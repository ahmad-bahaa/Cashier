import 'package:cashier/screens/bills_screen/bills_screen.dart';
import 'package:cashier/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     height: size / 3,
          //     width: size /3,
          //     decoration: BoxDecoration(
          //       color: Colors.blue,
          //       border: Border.all(color: Colors.black, width: 1),
          //       borderRadius: BorderRadius.circular(10),
          //       boxShadow: const [
          //         BoxShadow(
          //           offset: Offset(0.0, 1.0),
          //           blurRadius: 4.0,
          //           blurStyle: BlurStyle.normal,
          //         ),
          //       ],
          //     ),
          //     child: Hero(
          //       tag: 'logo',
          //       child: Center(
          //         child: Image.asset(
          //           'assets/images/logo-placeholder.png',
          //           height: 250,
          //           width: 250,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() =>  BillsScreen(isCelling: false,));
                  },
                  child: const LabelCard(
                      icon: Icons.add_shopping_cart, label: 'المشتريات'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() =>  BillsScreen(isCelling: true,));
                  },
                  child: const LabelCard(
                      icon: Icons.post_add_outlined, label: ' المبيعات'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const CashScreen());
                  },
                  child: const LabelCard(icon: Icons.money, label: 'الخزنة'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => CustomersScreen());
                  },
                  child: const LabelCard(icon: Icons.group, label: 'العملاء'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => const StockScreen(),
                    );
                  },
                  child: const LabelCard(
                      icon: Icons.shopping_cart, label: 'المخزن'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => const StockScreen(),
                    );
                  },
                  child: const LabelCard(
                      icon: Icons.shopping_cart, label: 'المخزن'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
