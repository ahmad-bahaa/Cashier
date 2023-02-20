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
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'كاشير اب',
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
            // ListTile(
            //   title: const Text(
            //     'عن التطبيق',
            //     style: TextStyle(fontSize: 24),
            //   ),
            //   onTap: () {
            //     // Update the state of the app.
            //     // ...
            //   },
            // ),
            // ListTile(
            //   title: const Text(
            //     'تفعيل التطبيق ',
            //     style: TextStyle(fontSize: 24),
            //   ),
            //   onTap: () {
            //     // Get.to(() => const PrivacyScreen());
            //     // Update the state of the app.
            //     // ...
            //   },
            // ),
            ListTile(
              title: const Text(
                'سياسة الخصوصية',
                style: TextStyle(fontSize: 24),
              ),
              onTap: () {
                Get.to(() => const PrivacyScreen());
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text(
                'المساعدة',
                style: TextStyle(fontSize: 24),
              ),
              onTap: () {
                Get.to(() => const HelpScreen());
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text(
                'تسجيل خروج',
                style: TextStyle(fontSize: 24),
              ),
              onTap: () {
                authController.signOutUser();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
        centerTitle: true,
        /*actions: [
         // PopupMenuButton(
         //   onSelected: (value) {
          //    if (value == 0) {
          //      authController.signOutUser();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                child: Text('تسجيل خروج'),
                value: 0,
              ),
            ],
          ),
        ], */
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
                      icon: Icons.bookmark_add, label: ' قائمة المبيعات'),
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
                      icon: Icons.auto_awesome_motion,
                      label: ' قائمة المشتريات'),
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
                    Tasks().showAction(context, 7,false,);
                  },
                  child: const LabelCard(
                      icon: Icons.reduce_capacity, label: ' حجم تعامل عميل'),
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
