import 'dart:io';

import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/screens/cash_screens/add_cash_screen.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/services/tasks.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class AddBillScreen extends StatelessWidget {
  AddBillScreen({
    Key? key,
    required this.isCelling,
  }) : super(key: key);

  final TextEditingController typeAheadPersonController =
  TextEditingController();
  final TextEditingController typeAheadProductController =
  TextEditingController();
  final TextEditingController quantityTextController = TextEditingController();
  final TextEditingController priceTextController = TextEditingController();

  final DataBaseServices dataBaseServices = DataBaseServices();

  final ProductController productController = Get.put(ProductController());
  final BillController billController = Get.put(BillController());
  final PersonController personController = Get.put(PersonController());

  DateTime dateTime = DateTime.now();

  final bool isCelling;
  late bool isOngoing;
  List<Bill> bills = [];

  @override
  Widget build(BuildContext context) {
    bills =
    isCelling ? billController.ongoingBills : billController.incomingBills;

    String billType = isCelling ? 'ongoingBills' : 'incomingBills';
    String cashType = isCelling ? 'celling' : 'buying';

    String formattedDate = DateFormat('yyyy-MM-dd ').format(dateTime);

    return WillPopScope(
      onWillPop: () =>
          _onWillPop(
            context,
            cashType,
            billType,
            false,
            false,
          ),
      child: Scaffold(
        appBar: AppBar(
          title:
          Text(isCelling ? 'فاتورة مبيعات جديدة' : 'فاتورة مشتريات جديدة'),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                if (value == 1) {
                  _onWillPop(
                    context,
                    cashType,
                    billType,
                    true,
                    true,
                  );
                } else {
                  _onWillPop(
                    context,
                    cashType,
                    billType,
                    true,
                    false,
                  );
                }
              },
              itemBuilder: (context) =>
              const [
                PopupMenuItem(
                  child: Text('دفع نقدية'),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text('استلام نقدية'),
                  value: 2,
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Obx(
              () =>
              CustomBottomAppBar(
                buttonText:
                '${double.parse(
                    billController.totalBillPrice.value.toStringAsFixed(
                        2))}حفظ  - اجمالي ',
                onPressed: () {
                  validateBill(cashType, billType, false, false);
                },
              ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formattedDate,
                ),
                CustomTypeAheadPerson(
                  typeAheadController: typeAheadPersonController,
                  billController: billController,
                  isBill: true,
                  isEnabled: true,
                ),
                CustomTypeAheadProduct(
                  typeAheadController: typeAheadProductController,
                  productController: productController,
                  billController: billController,
                  isCelling: isCelling,
                ),
                // totalAndQuantityRow(billController: billController),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children:  [
                    // ElevatedButton(
                    //   onPressed: () {
                    //     if (billController.product.isNotEmpty) {
                    //       if (int.parse(
                    //                   billController.product['billQuantity']) >
                    //               int.parse(
                    //                   billController.product['quantity']) &&
                    //           isCelling) {
                    //         Tasks().showErrorMessage('خطأ', 'غير متاح بالمخزن');
                    //       } else if (int.parse(
                    //               billController.product['billQuantity']) >=
                    //           1) {
                    //         billController.addProduct.add(
                    //           Product(
                    //             id: billController.product['id'] ?? 0,
                    //             name: billController.product['name'] ?? '',
                    //             buyPrice: double.parse(
                    //                 billController.product['total'] ?? '0.0'),
                    //             cellPrice: isCelling
                    //                 ? double.parse(billController
                    //                         .product['billCellPrice'] ??
                    //                     '0.0')
                    //                 : double.parse(billController
                    //                         .product['billBuyPrice'] ??
                    //                     '0.0'),
                    //             quantity: int.parse(
                    //                 billController.product['billQuantity'] ??
                    //                     '0'),
                    //             lastPrice:
                    //                 billController.product['lastPrice'] ?? 0.0,
                    //           ),
                    //         );
                    //
                    //         billController.updatingBillTotal();
                    //         billController.product.clear();
                    //         quantityTextController.clear();
                    //         priceTextController.clear();
                    //         typeAheadProductController.clear();
                    //       } else {
                    //         Tasks().showErrorMessage(
                    //             'خطأ', 'من فضلك ادخل كمية صحيحة');
                    //       }
                    //     } else {
                    //       Tasks().showErrorMessage('خطأ', 'من فضلك اختار صنف');
                    //     }
                    //   },
                    //   child: const Icon(
                    //     Icons.download,
                    //   ),
                    // ),
                //   ],
                // ),
                const Divider(
                  thickness: 2.0,
                  color: Colors.black,
                ),
                Obx(
                      () =>
                      Column(
                        children: [
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 15,
                            color: Colors.grey[300],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                SingleUnit(text: 'الاجمالي', width: 55),
                                SingleUnit(text: 'السعر', width: 50),
                                SingleUnit(text: 'الكمية', width: 40),
                                SingleUnit(text: 'اسم الصنف', width: 120),
                                SingleUnit(text: 'م', width: 20),
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 1.0,
                            color: Colors.black,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: billController.addProduct.length,
                            itemBuilder: (context, index) {
                              Product item = billController.addProduct[index];
                              return InkWell(
                                onLongPress: () {
                                  removeProduct(index);

                                  Tasks().showHintMessage(
                                      '', 'تم ازالة الصنف ');
                                },
                                child: RowBillCard(
                                  product: item,
                                  i: index + 1,
                                  isCelling: isCelling,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context,
      String cashType,
      String billType,
      bool isPaying,
      bool paidCashType,) async {
    if (billController.addProduct.isNotEmpty) {
      return await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('يوجد فاتورة'),
              content: const Text('هل تريد الحفظ ؟'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    // //TODO: it doesn't work
                    // int i = 0;
                    // do {
                    //   removeProduct(0);
                    // } while (billController.addProduct.length > 0);
                    Navigator.of(context).pop(false);
                    // for (var i in  billController.addProduct) {
                    //   await removeProduct(i.);
                    // }

                    // billController.addProduct.isNotEmpty
                    //     ? null
                    //     : Navigator.of(context).pop(true);
                  },
                  child: const Text('لا'),
                ),
                TextButton(
                  onPressed: () {
                    validateBill(cashType, billType, isPaying, paidCashType);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('نعم'),
                ),
              ],
            ),
      );
    } else if (isPaying) {
      return await Get.to(() =>
          AddCashScreen(
            isSending: paidCashType,
          ));
    } else {
      return true;
    }
  }

  InkWell buildInkWell(BuildContext context, String text, int i) {
    return InkWell(
      onTap: () => Tasks().showAction(context, i),
      child: SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text),
              const Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }

  removeProduct(int index) {
    int id = billController.addProduct[index].id;
    final q = productController.products.where((p0) {
      return p0.id.isEqual(id);
    }).toList();
    dataBaseServices.updateProduct(id, q[0].quantity,
        billController.addProduct[index].quantity, !isCelling);

    billController.addProduct.remove(billController.addProduct[index]);
    billController.updatingBillTotal();
  }

  updatingProductInfo(String data, String value) {
    billController.product.update(
      data,
          (_) => value,
      ifAbsent: () => value,
    );
  }

  validateBill(String cashType, String billType, bool isPaying,
      bool paidCashType) {
    //TODO: need Modification
    if (billController.addProduct.isNotEmpty &&
        billController.newBill.isNotEmpty) {
      final q = personController.people.where((p0) {
        return p0.id.isEqual(billController.newBill['personId']);
      }).toList();
      dataBaseServices.updatePersonCash(q[0].id, q[0].owned.toDouble(),
          billController.totalBillPrice.value.toDouble(), 'owned');
      //TODO: needs modification
      addBillToDatabase(cashType, billType);
      isPaying
          ? Get.to(() =>
          AddCashScreen(
            isSending: paidCashType,
          ))
          : null;
    } else if (billController.addProduct.isNotEmpty) {
      addBillToDatabase(cashType, billType);
      isPaying
          ? Get.to(() =>
          AddCashScreen(
            isSending: paidCashType,
          ))
          : null;
    } else {
      Tasks().showErrorMessage('خطأ', 'من فضلك اضف اصناف');
    }
  }

  addBillToDatabase(String cashType, String billType) async {
    dataBaseServices.addBill(
        Bill(
          id: bills.length + 1,
          uid: billController.newBill['uid'] ?? 0,
          name: billController.newBill['name'] ?? 'بدون اسم',
          price: billController.totalBillPrice.value.toInt(),
          date: DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now()),
          products: billController.addProduct,
        ),
        billType);
    dataBaseServices.updateCash(
        cashType, billController.totalBillPrice.value.toDouble(), false);
    dataBaseServices.updateCash('earnings',
        billController.totalBillEarnings.value.toDouble(), isCelling);
    addBillProductsToDatabase(billType, bills.length + 1);
    billController.product.clear();
    typeAheadPersonController.clear();
    typeAheadProductController.clear();
    quantityTextController.clear();
    priceTextController.clear();
    billController.newBill.clear();
    billController.addProduct.clear();
    billController.totalBillPrice.value = 0;
    Tasks().showSuccessMessage('', 'تم إاضافة فاتورة');
  }

  addBillProductsToDatabase(String billType, int billID) async {
    for (int i = 0; i < billController.addProduct.length; i++) {
      dataBaseServices.addBillProducts(
          billController.addProduct[i], billType, billID);
    }
  }
}

class TotalAndQuantityRow extends StatelessWidget {
  const TotalAndQuantityRow({
    Key? key,
    required this.billController,
  }) : super(key: key);

  final BillController billController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(
              () =>
              Text(
                billController.product['total'] ?? '0',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue),
              ),
        ),
        const Text(
          'الاجمالي ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Obx(
              () =>
              Text(
                billController.product['quantity'] ?? '0',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue),
              ),
        ),
        const Text(
          'الكمية المتاحة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
