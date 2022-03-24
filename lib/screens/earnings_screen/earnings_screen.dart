import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EarningsScreen extends StatelessWidget {
  EarningsScreen({Key? key}) : super(key: key);
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
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
                .doc('ji7k9SxbxfHUqDctJx1W')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var output = snapshot.data!.data();
                var celling = output!['celling'];
                var buying = output!['buying'];
                var spending = output!['spending'];
                int earning = celling - buying - spending;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MoneyFlow(
                      cash: earning.toString(),
                      type: ' : الارباح',
                      // color: Colors.green,
                    ),
                    const Divider(
                      height: 3.0,
                      thickness: 3.0,
                      color: Colors.black,
                    ),
                    MoneyFlow(
                      cash: celling.toString(),
                      type: ' : المبيعات',
                      // color: Colors.green,
                    ),
                    const Divider(
                      height: 3.0,
                      thickness: 3.0,
                      color: Colors.black,
                    ),
                    MoneyFlow(
                      cash: buying.toString(),
                      type: ' : المشتريات',
                      // color: Colors.green,
                    ),
                    const Divider(
                      height: 3.0,
                      thickness: 3.0,
                      color: Colors.black,
                    ),
                    MoneyFlow(
                      cash: spending.toString(),
                      type: ' : المصروفات',
                      // color: Colors.green,
                    ),
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

class MoneyFlow extends StatelessWidget {
  const MoneyFlow({
    Key? key,
    required this.cash,
    required this.type,
  }) : super(key: key);
  final String cash, type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        margin: const EdgeInsets.only(right: 12.0),
        child: Column(
          children: [
            Text(
              type,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                cash,
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}