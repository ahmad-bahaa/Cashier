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
                int celling = output?['celling'] ?? 0;
                int buying = output?['buying'] ?? 0;
                int spending = output?['spending'] ?? 0;
                int earning = celling - buying - spending;
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
                        cash: earning.toString(),
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

