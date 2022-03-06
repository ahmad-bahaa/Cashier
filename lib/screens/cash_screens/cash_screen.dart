import 'package:cashier/controllers/cash_controller.dart';
import 'package:cashier/screens/cash_screens/add_cash_screen.dart';
import 'package:cashier/screens/cash_screens/cash_reports_screen.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashScreen extends StatefulWidget {
  const CashScreen({Key? key}) : super(key: key);

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  CashController cashController = Get.put(CashController());
  DataBaseServices dataBaseServices = DataBaseServices();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('الخزنة'),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            controller: _controller,
            tabs: const [
              Tab(
                text: "تم دفع",
              ),
              Tab(
                text: "تم استلام",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: _fireStore
                          .collection('users')
                          .doc('ji7k9SxbxfHUqDctJx1W')
                          .snapshots(),
                      builder: (context, snapshot) {
                      if (snapshot.hasData) {
                          var output = snapshot.data!.data();
                          var value = output!['money'].toString();
                          return Text(
                            value,
                            style: const TextStyle(
                                fontSize: 28,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          );
                        }else{
                        return const SizedBox();
                      }
                      }),
                  const Text(
                    ' : اجمالي المبلغ',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  CashReportScreen(
                    cashType: true,
                  ),
                  CashReportScreen(
                    cashType: false,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  function() {
    Get.to(() => AddCashScreen());
  }
}
