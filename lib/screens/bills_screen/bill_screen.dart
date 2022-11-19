import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/widgets/custom_app_bar.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final PersonController personController = Get.put(PersonController());

  @override
  Widget build(BuildContext context) {
    String billType = isCelling ? 'ongoingBills' : 'incomingBills';
    int i = 0;
     int uid = bill.uid - 1;
    Person? person = uid == -1 ? null : personController.people[uid];
    String phone = person?.phoneNumber ?? ' لا يوجد';
    String address = person?.address ?? ' لا يوجد';


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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ' التاريخ:  ${bill.date}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    ' م : ${bill.id} ',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),

              // const SizedBox(height: 5),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        person?.name ?? 'بدون اسم' ,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const Text(
                        ' - ',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const Text(
                        ' العميل ',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                       phone,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const Text(
                        ' - ',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const Text(
                        ' رقم الهاتف ',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        address,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const Text(
                        ' - ',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const Text(
                        ' العنوان ',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                    ],
                  ),
                ],
              ),

              const Divider(
                color: Colors.black,
                thickness: 1,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  SingleUnit(
                    text: 'الاجمالي',
                    width: 55,
                    isBold: true,
                  ),
                  SingleUnit(
                    text: 'السعر',
                    width: 50,
                    isBold: false,
                  ),
                  SingleUnit(
                    text: 'الكمية',
                    width: 40,
                    isBold: false,
                  ),
                  SingleUnit(
                    text: 'اسم الصنف',
                    width: 120,
                    isBold: false,
                  ),
                  SingleUnit(
                    text: 'م',
                    width: 20,
                    isBold: false,
                  ),
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
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Product product = Product.fromSnapShot(document);
                          i = i + 1;
                          return RowBillCard(
                            product: product,
                            isCelling: isCelling,
                            i: i,
                          );
                        }).toList(),
                      );
                    }),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Text(
                ' اجمالي : ${bill.price}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              const Center(
                child: Text(
                  'كاشير للمحاسبة - 01556533914',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
