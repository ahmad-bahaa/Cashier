import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/cash_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCashReportScreen extends StatelessWidget {
  UserCashReportScreen({
    Key? key,
    required this.billType,
  }) : super(key: key);

  final DataBaseServices dataBaseServices = DataBaseServices();
  final BillController billController = Get.put(BillController());
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final String billType;

  List<Bill> bills = <Bill>[];

  @override
  Widget build(BuildContext context) {
    String userUid = AuthController().firebaseAuth.currentUser!.uid.toString();

    bills = billController.queryBills;
    int uid = billController.newBill['uid'];
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore
            .collection('users')
            .doc(userUid)
            .collection(billType)
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Cash cash = Cash.fromSnapShot(document);
              // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return InkWell(child: buildBillReportRow(cash));
            }).toList(),
          );
        });
  }

  CustomContainer buildBillReportRow(Cash cash) {
    return CustomContainer(
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                //TODO: this should be total Bill Cost
                cash.money.toString(),
                style: const TextStyle(fontSize: 24, color: Colors.green),
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
