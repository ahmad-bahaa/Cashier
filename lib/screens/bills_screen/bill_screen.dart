import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';

import '../../controllers/product_controller.dart';

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
  final ProductController productController = Get.put(ProductController());

  final BillController billController = Get.put(BillController());

  String billType = '';

  @override
  Widget build(BuildContext context) {
    billType = isCelling ? 'ongoingBills' : 'incomingBills';
    int i = 0;

    // int id =  bill.uid - 1;
    // Person? person = id == 0  ? null : personController.people[id];
    // String phone = person?.phoneNumber ?? ' لا يوجد';
    // String address = person?.address ?? ' لا يوجد';

    String userUid = AuthController().firebaseAuth.currentUser!.uid.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(isCelling ? 'فاتورة مبيعات ' : 'فاتورة مشتريات '),
        // actions: [
        //   PopupMenuButton(
        //     onSelected: (value) {
        //       if (value == 1) {
        //         //TODO: ADD PRODUCT TO THE BILL
        //         billController.product
        //             .update('existing', (_) => 'yes', ifAbsent: () => 'yes');
        //         Tasks().showAction(
        //           context,
        //           8,
        //           isCelling,
        //         );
        //       }
        //     },
        //     itemBuilder: (context) => const [
        //       PopupMenuItem(
        //         child: Text('اضافة صنف '),
        //         value: 1,
        //       ),
        //     ],
        //   ),
        // ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                        style: const TextStyle(fontSize: 14.0),
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
                            bill.name,
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
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
                            children: const [
                              Text(
                                '',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                ' - ',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                ' رقم الهاتف ',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Text(
                                '',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                ' - ',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                ' العنوان ',
                                style: TextStyle(fontSize: 18.0),
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
                  StreamBuilder<QuerySnapshot>(
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

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        }
                        // snapshot.data!.docs.map((e) =>
                        //      Product.fromSnapShot(e)).toList();
                        //  ),
                        List<Product> currentProducts = snapshot.data!.docs.map((e) => Product.fromSnapShot(e)).toList();
                        return ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {

                            String id = document.id;
                            Product product = Product.fromSnapShot(document);
                            i = i + 1;
                            return InkWell(
                              onLongPress: () {
                                removeSingleProduct(
                                    product, bill, billType, isCelling, id,currentProducts.length);
                                Get.back();
                              },
                              child: RowBillCard(
                                product: product,
                                isCelling: isCelling,
                                i: i,
                              ),
                            );
                          }).toList(),
                        );
                      }),
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
                  Text(
                    Tafqeet.convert(bill.price.toString()),
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
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  removeSingleProduct(
      Product product, Bill bill, String billType, bool isCelling, String id,int length) {
    final q = productController.products.where((element) {
      return element.id.isEqual(product.id);
    }).toList();
    double totalPrice = product.quantity * product.cellPrice;
    double finalPrice = bill.price - totalPrice;
    dataBaseServices.updateProductPrice(billType, bill.id, 'price', finalPrice);
    dataBaseServices.updateProduct(
        product.id, q[0].quantity, product.quantity, !isCelling);
    if (isCelling) {
      double cellPrice = product.quantity * q[0].cellPrice;
      double earningsCalc = cellPrice - totalPrice;
      dataBaseServices.updateCash('earnings', earningsCalc, true);
    }
    if(length == 1){
      dataBaseServices.removeBill(billType,bill.id);
    }
    if (bill.uid != 0) {
      final person = personController.people.where((element) {
        return element.id.isEqual(bill.uid);
      }).toList();
      dataBaseServices.updatePersonCash(
          bill.uid,
          isCelling ? person[0].owned.toDouble() : person[0].paid.toDouble(),
          finalPrice * -1,
          isCelling ? 'owned' : 'paid');
    }
    dataBaseServices.removeProductFromBill(billType, bill.id, id);
  }
}
