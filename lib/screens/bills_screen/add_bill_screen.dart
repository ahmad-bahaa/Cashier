import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/product_model.dart';
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

    String formattedDate = DateFormat('yyyy-MM-dd ').format(dateTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة فاتورة'),
        centerTitle: true,
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomAppBar(
          buttonText: billController.totalBillPrice.value.toStringAsFixed(2),
          onPressed: () {
            //TODO: need Modification
            if (billController.addProduct.isNotEmpty) {
              int id = bills.length + 1;
              dataBaseServices.addBill(
                  Bill(
                    id: id,
                    name: billController.newBill['name'] ?? 'بدون اسم',
                    price: billController.totalBillPrice.value.toInt(),
                    date:
                        DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now()),
                    products: billController.addProduct,
                  ),
                  billType);
              billController.newBill.clear();
              billController.addProduct.clear();
              billController.totalBillPrice.value = 0;
              Get.back();
            } else {
              Get.snackbar('خطأ', 'من فضلك اضف اصناف');
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
              ),
              CustomTypeAheadProduct(
                typeAheadController: typeAheadProductController,
                productController: productController,
                billController: billController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => Text(
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
                    () => Text(
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (billController.product.isNotEmpty) {
                        if (int.parse(billController.product['billQuantity']) >
                            int.parse(billController.product['quantity'])) {
                          Get.snackbar('خطأ', 'غير متاح بالمخزن');
                        } else if (int.parse(
                                billController.product['billQuantity']) >=
                            1) {
                          billController.addProduct.add(
                            Product(
                              id: billController.product['id'] ?? 0,
                              name: billController.product['name'] ?? '',
                              buyPrice: int.parse(
                                  billController.product['total'] ?? '0'),
                              cellPrice: int.parse(
                                  billController.product['billCellPrice'] ??
                                      '0'),
                              quantity: int.parse(
                                  billController.product['billQuantity'] ??
                                      '0'),
                            ),
                          );
                          billController.updatingBillTotal();
                          billController.product.clear();
                          quantityTextController.clear();
                          priceTextController.clear();
                          typeAheadProductController.clear();
                        } else {
                          Get.snackbar('خطأ', 'من فضلك ادخل كمية صحيحة');
                        }
                      } else {
                        Get.snackbar('خطأ', 'من فضلك اختار صنف');
                      }
                    },
                    child: const Icon(
                      Icons.download,
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: CustomTextFormField(
                      data: 'data',
                      hintText: 'الكمية',
                      controller: quantityTextController,
                      textInputType: TextInputType.number,
                      validatorHint: 'يجب إدخال الكمية',
                      iconData: Icons.person,
                      textMaxLength: 5,
                      onChanged: (value) {
                        updatingProductInfo('billQuantity', value);
                        int i = int.parse(
                                billController.product['billQuantity']) *
                            int.parse(billController.product['billCellPrice']);
                        updatingProductInfo('total', i.toString());
                      },
                    ),
                  ),
                  SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () => _showAction(context, 4),
                        child: Obx(() => Text(billController.product['billCellPrice'] ?? 'سعر البيع')),
                      )),
                ],
              ),
              const Divider(
                thickness: 2.0,
                color: Colors.black,
              ),
              Obx(
                () => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SingleUnit(text: 'كود', width: 50),
                        SingleUnit(text: 'اسم الصنف', width: 110),
                        SingleUnit(text: 'الكمية', width: 50),
                        SingleUnit(text: 'السعر', width: 50),
                        SingleUnit(text: 'الاجمالي', width: 50),
                      ],
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
                        return RowBillCard(product: item);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleUnit(
                          text: billController.totalBillPrice.value
                              .toStringAsFixed(2),
                          width: 100,
                        ),
                        const SingleUnit(text: 'الاجمالي', width: 50),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          index: index,
          color: Colors.red,
        );
      },
    );
  }
}
