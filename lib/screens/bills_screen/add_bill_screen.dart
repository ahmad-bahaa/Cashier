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
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة فاتورة'),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                if (value == 1) {
                  Get.to(() => AddCashScreen(
                        isSending: true,
                      ));
                } else {
                  Get.to(() => AddCashScreen(
                        isSending: false,
                      ));
                }
              },
              itemBuilder: (context) => const [
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
          () => CustomBottomAppBar(
            buttonText:
                '${billController.totalBillPrice.value.toStringAsFixed(2)} الاجمالي ',
            onPressed: () {
              //TODO: need Modification
              if (billController.addProduct.isNotEmpty) {
                final q = personController.people.where((p0) {
                  return p0.id.isEqual(billController.newBill['personId']);
                }).toList();
                dataBaseServices.addBill(
                    Bill(
                      id: bills.length + 1,
                      name: billController.newBill['name'] ?? 'بدون اسم',
                      price: billController.totalBillPrice.value.toInt(),
                      date: DateFormat('yyyy-MM-dd - kk:mm')
                          .format(DateTime.now()),
                      products: billController.addProduct,
                    ),
                    billType);
                dataBaseServices.updatePersonCash(q[0].id, q[0].owned,  billController.totalBillPrice.value.toInt(), 'owned');
                //TODO: needs modification
                dataBaseServices.updateCash(cashType,
                    billController.totalBillPrice.value.toInt(), false);
                billController.product.clear();
                // billController.updatingProductsQuantity(isCelling);
                typeAheadPersonController.clear();
                typeAheadProductController.clear();
                quantityTextController.clear();
                priceTextController.clear();
                billController.newBill.clear();
                billController.addProduct.clear();
                billController.totalBillPrice.value = 0;
                Tasks().showSuccessMessage(
                    'عملية ناجحة', 'تم إاضافة فاتورة إلى قاعدة البيانات');
              } else {
                Tasks().showErrorMessage('خطأ', 'من فضلك اضف اصناف');
              }
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
                ),
                CustomTypeAheadProduct(
                  typeAheadController: typeAheadProductController,
                  productController: productController,
                  billController: billController,
                  isCelling: isCelling,
                ),
                // totalAndQuantityRow(billController: billController),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (billController.product.isNotEmpty) {
                          if (int.parse(
                                      billController.product['billQuantity']) >
                                  int.parse(
                                      billController.product['quantity']) &&
                              isCelling) {
                            Tasks().showErrorMessage('خطأ', 'غير متاح بالمخزن');
                          } else if (int.parse(
                                  billController.product['billQuantity']) >=
                              1) {
                            billController.addProduct.add(
                              Product(
                                id: billController.product['id'] ?? 0,
                                name: billController.product['name'] ?? '',
                                buyPrice: int.parse(
                                    billController.product['total'] ?? '0'),
                                cellPrice: isCelling
                                    ? int.parse(billController
                                            .product['billCellPrice'] ??
                                        '0')
                                    : int.parse(billController
                                            .product['billBuyPrice'] ??
                                        '0'),
                                quantity: int.parse(
                                    billController.product['billQuantity'] ??
                                        '0'),
                              ),
                            );
                            //Todo: put this somewhere else
                            dataBaseServices.updateProduct(
                                billController.product['id'],
                                int.parse(billController.product['quantity']),
                                int.parse(
                                    billController.product['billQuantity']),
                                isCelling);
                            billController.updatingBillTotal();
                            billController.product.clear();
                            quantityTextController.clear();
                            priceTextController.clear();
                            typeAheadProductController.clear();
                          } else {
                            Tasks().showErrorMessage(
                                'خطأ', 'من فضلك ادخل كمية صحيحة');
                          }
                        } else {
                          Tasks().showErrorMessage('خطأ', 'من فضلك اختار صنف');
                        }
                      },
                      child: const Icon(
                        Icons.download,
                      ),
                    ),
                    // SizedBox(
                    //   width: 120,
                    //   child: CustomTextFormField(
                    //     data: 'data',
                    //     hintText: 'الكمية',
                    //     controller: quantityTextController,
                    //     textInputType: TextInputType.number,
                    //     validatorHint: 'يجب إدخال الكمية',
                    //     iconData: Icons.person,
                    //     textMaxLength: 5,
                    //     onChanged: (value) {
                    //       updatingProductInfo('billQuantity', value);
                    //       int i = int.parse(
                    //               billController.product['billQuantity']) *
                    //           int.parse(
                    //               billController.product['billCellPrice'] ?? '0');
                    //       updatingProductInfo('total', i.toString());
                    //     },
                    //   ),
                    // ),
                    // SizedBox(
                    //     width: 120,
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         if (billController.product.isNotEmpty) {
                    //           Tasks().showAction(context, isCelling ? 4 : 5);
                    //         } else {
                    //           Tasks().showErrorMessage(
                    //               'خطأ', 'من فضلك اختار صنف اولا');
                    //         }
                    //       },
                    //       child: Obx(() => Text(isCelling
                    //           ? billController.product['billCellPrice'] ??
                    //               'سعر البيع'
                    //           : billController.product['billBuyPrice'] ??
                    //               'سعر الشراء')),
                    //     )),
                  ],
                ),
                const Divider(
                  thickness: 2.0,
                  color: Colors.black,
                ),
                Obx(
                  () => Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 15,
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
                              int id = billController.addProduct[index].id;
                              final q = productController.products.where((p0) {
                                return p0.id.isEqual(id);
                              }).toList();
                              dataBaseServices.updateProduct(
                                  id,
                                  q[0].quantity,
                                  billController.addProduct[index].quantity,
                                  !isCelling);

                              billController.addProduct
                                  .remove(billController.addProduct[index]);
                              billController.updatingBillTotal();
                              Tasks()
                                  .showHintMessage('', 'تم ازالة الصنف بنجاح');
                            },
                            child: RowBillCard(
                              product: item,
                              i: index + 1,
                              billController: billController,
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

  Future<bool> _onWillPop(BuildContext context) async {
    if (billController.addProduct.isNotEmpty) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('هل تريد الإلغاء؟'),
          content: const Text('يوجد فاتورة لم يتم حفظها'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              //<-- SEE HERE
              child: const Text('لا'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              // <-- SEE HERE
              child: const Text('نعم'),
            ),
          ],
        ),
      );
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

  updatingProductInfo(String data, String value) {
    billController.product.update(
      data,
      (_) => value,
      ifAbsent: () => value,
    );
  }
}

class totalAndQuantityRow extends StatelessWidget {
  const totalAndQuantityRow({
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
          () => Text(
            billController.product['total'] ?? '0',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
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
          () => Text(
            billController.product['quantity'] ?? '0',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
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
