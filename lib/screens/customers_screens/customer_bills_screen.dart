import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/widgets/custom_type_ahead_person.dart';
import 'package:flutter/material.dart';
import 'package:cashier/screens/screens.dart';
import 'package:get/get.dart';

class CustomerBillsScreen extends StatefulWidget {
  const CustomerBillsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerBillsScreen> createState() => _CustomerBillsScreenState();
}

class _CustomerBillsScreenState extends State<CustomerBillsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  final BillController billController = Get.put(BillController());
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حجم تعامل'),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _controller,
          tabs: const [
            Tab(
              text: "مبيعات",
            ),
            Tab(
              text: "مشتريات",
            ),
            Tab(
              text: "استلام نقدية",
            ),
            Tab(
              text: "دفع نقدية",
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: CustomTypeAheadPerson(
              typeAheadController: textEditingController,
              billController: billController,
              isBill: false,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children:  [
                BillReportScreen(),
                BillReportScreen(),
                CashReportScreen(cashType: false, isSpending: false),
                CashReportScreen(cashType: true, isSpending: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
