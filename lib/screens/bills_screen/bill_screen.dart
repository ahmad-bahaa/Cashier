import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/widgets/custom_app_bar.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillScreen extends StatelessWidget {
  BillScreen({
    Key? key,
    required this.isCelling,
    required this.bill,
  }) : super(key: key);
  final bool isCelling;
  final Bill bill;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  DataBaseServices dataBaseServices = DataBaseServices();

  @override
  Widget build(BuildContext context) {
    String billType = isCelling ? 'ongoingBills' : 'incomingBills';
    int i = 0;

    // List<Product> products = dataBaseServices.getAllBillProducts(
    //     billType, bill.uid) as List<Product>;
    String userUid = AuthController().firebaseAuth.currentUser!.uid.toString();
    return Scaffold(
      appBar:
      CustomAppBar(title: isCelling ? 'فاتورة مبيعات ' : 'فاتورة مشتريات '),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Card(
                elevation: 2.0,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Cashier App',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              Text(
                ' التاريخ: ${bill.date}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              Text(
                ' مسلسل الفاتورة : ${bill.id} ',
                style: const TextStyle(fontSize: 18.0),
              ),
              Text(
                ' العميل: ${bill.name}',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              const Text(
                'رقم الهاتف: لايوجد',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 5),
              const Text(
                'العنوان: لايوجد ',
                style: TextStyle(fontSize: 18.0),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  SingleUnit(text: 'الاجمالي', width: 55),
                  SingleUnit(text: 'السعر', width: 50),
                  SingleUnit(text: 'الكمية', width: 40),
                  SingleUnit(text: 'اسم الصنف', width: 120),
                  SingleUnit(text: 'م', width: 20),
                ],
              ),
              const Divider(
                color: Colors.black,
                thickness: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _fireStore
                        .collection('users')
                        .doc(userUid)
                        .collection('billsProducts')
                        .doc(billType)
                        .collection(bill.id.toString())
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }
                     // snapshot.data!.docs.map((e) =>
                     //      Product.fromSnapShot(e)).toList();
                     //  ),
                      return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Product product = Product.fromSnapShot(document);
                      i = i+1;
                      return RowBillCard(product: product,isCelling: isCelling,i: i,);
                      }).toList(),
                      );

                      // return ListView.builder(
                      // shrinkWrap: true,
                      // itemCount: products.length,
                      // itemBuilder: (context, index) {
                      // return Card(
                      // elevation: 0.0,
                      // child: RowBillCard(
                      // isCelling: isCelling,
                      // product: Product(
                      // name: 'صنف $index',
                      // id: index,
                      // lastPrice: 10,
                      // quantity: 20,
                      // buyPrice: 10,
                      // cellPrice: 10,
                      // ),
                      // i: index + 1,
                      // ),
                      // );
                      // });
                    }),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Text(
                ' اجمالي : ${bill.price}',
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
