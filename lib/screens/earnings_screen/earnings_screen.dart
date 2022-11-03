import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/widgets/custom_container.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  EarningsScreen({Key? key}) : super(key: key);
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String userUid = AuthController().firebaseAuth.currentUser!.uid.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('حركة الاموال'),
        centerTitle: true,
      ),
      body: SizedBox(
        // width: MediaQuery.of(context).size.width,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _fireStore
                .collection('users')
                .doc(userUid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var output = snapshot.data!.data();
                double celling = double.parse(output?['celling'].toString() ?? '0.0');
                double buying = double.parse(output?['buying'].toString() ?? '0.0');
                double spending = double.parse(output?['spending'].toString() ?? '0.0');
                double earnings = double.parse(output?['earnings'].toString() ?? '0.0');
                double finalEarnings = earnings - spending;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    MoneyFlow(
                      cash: celling.toString(),
                      type: ' : المبيعات',
                      color: Colors.green,
                    ),
                    const Divider(
                      height: 3.0,
                      thickness: 3.0,
                      color: Colors.black,
                    ),
                    MoneyFlow(
                      cash: buying.toString(),
                      type: ' : المشتريات',
                      color: Colors.green,
                    ),
                    const Divider(
                      height: 3.0,
                      thickness: 3.0,
                      color: Colors.black,
                    ),
                    MoneyFlow(
                      cash: spending.toString(),
                      type: ' : المصروفات',
                      color: Colors.green,
                    ),
                    const Divider(
                      height: 3.0,
                      thickness: 3.0,
                      color: Colors.black,
                    ),
                    CustomContainer(widget:  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [ MoneyFlow(
                        cash: finalEarnings.toString(),
                        type: ' : الارباح',
                        color: Colors.blue,
                      ),],
                    ), color: Colors.white)


                  ],
                );
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }
}

