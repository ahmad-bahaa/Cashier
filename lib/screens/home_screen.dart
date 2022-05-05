import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/screens/bills_screen/bills_screen.dart';
import 'package:cashier/screens/cash_screens/add_spending_screen.dart';
import 'package:cashier/screens/customer_report_screens/customer_reports_screen.dart';
import 'package:cashier/screens/screens.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/services/tasks.dart';
import 'package:flutter/material.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 0) {
                authController.signOutUser();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                child: Text('تسجيل خروج'),
                value: 0,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => BillsScreen(
                          isCelling: true,
                        ));
                  },
                  child: const LabelCard(
                      icon: Icons.bookmark_add, label: ' المبيعات'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => AddBillScreen(isCelling: true));
                  },
                  child: const LabelCard(
                      icon: Icons.post_add_outlined, label: 'فاتورة مبيعات'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => BillsScreen(
                          isCelling: false,
                        ));
                  },
                  child: const LabelCard(
                      icon: Icons.auto_awesome_motion, label: ' المشتريات'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => AddBillScreen(isCelling: false));
                  },
                  child: const LabelCard(
                      icon: Icons.post_add_outlined, label: 'فاتورة مشتريات'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => const CashScreen());
                  },
                  child:
                      const LabelCard(icon: Icons.local_atm, label: 'الخزنة'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => CustomersScreen());
                  },
                  child: const LabelCard(icon: Icons.groups, label: 'العملاء'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => const StockScreen(),
                    );
                  },
                  child: const LabelCard(
                      icon: Icons.production_quantity_limits,
                      label: 'جرد و نواقص'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => AddProductScreen(),
                    );
                  },
                  child: const LabelCard(
                      icon: Icons.add_shopping_cart, label: 'إضافة صنف'),
                ),
                InkWell(
                  onTap: () {
                   Tasks().showAction(context, 7);
                  },
                  child: const LabelCard(
                      icon: Icons.reduce_capacity, label: 'حجم تعامل'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => EarningsScreen(),
                    );
                  },
                  child: const LabelCard(
                      icon: Icons.currency_exchange_outlined, label: 'الارباح'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
