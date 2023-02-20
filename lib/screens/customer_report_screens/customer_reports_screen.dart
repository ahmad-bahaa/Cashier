import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/controllers/bill_controller.dart';
import 'package:flutter/cupertino.dart';
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
    int uid = billController.newBill['uid'];
    int owned = billController.newBill['owned'];
    int paid = billController.newBill['paid'];
    int total = owned - paid;
    String moneyType = total > 0 ? 'مدين' : 'دائن' ;
    Color color = total > 0 ? Colors.green : Colors.red;
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
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          //   child: CustomTypeAheadPerson(
          //     typeAheadController: textEditingController,
          //     billController: billController,
          //     isBill: false,
          //   ),
          // ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                BillReportScreen(isCelling: true, billType: 'ongoingBills'),
                BillReportScreen(isCelling: false, billType: 'incomingBills'),
                UserCashReportScreen(
                  billType: 'receiving',
                ),
                UserCashReportScreen(billType: 'sending'),
              ],
            ),
          ),

         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text( total.abs().toString(),style: const TextStyle(fontSize: 24),),
             const SizedBox(width: 10,),
             Text(moneyType ,style:  TextStyle(fontSize: 24,color: color),),
           ],
         )
        ],
      ),
    );
  }
}
