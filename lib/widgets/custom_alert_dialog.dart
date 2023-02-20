import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/services/tasks.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialog extends StatelessWidget {
  CustomAlertDialog({
    Key? key,
    required this.color,
    required this.index,
    required this.isCelling,
    this.typeAheadProductController,
    this.nameTextEditingController,
  }) : super(key: key);

  static const _actionTitles = [
    'رقم هاتف غير صحيح',
    'إضافة صنف',
    'إضافة فاتورة',
  ];
  final bool isCelling;
  final int index;
  final Color color;
  final _formKey = GlobalKey<FormState>();
  final PersonController _personController = Get.put(PersonController());
  final ProductController productController = Get.put(ProductController());
  final BillController billController = Get.put(BillController());
  final DataBaseServices _dataBaseServices = DataBaseServices();
  final TextEditingController? nameTextEditingController;
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController addressTextEditingController =
      TextEditingController();
  final TextEditingController? typeAheadProductController;
  final TextEditingController typeAheadPersonController =
      TextEditingController();

  String name = 'name';
  String personPhone = 'phone';
  String personAddress = 'address';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: _buildAlertDialogBody(index),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'إلغاء',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            switch (index) {
              case 0:
                {
                  Get.back();
                }
                break;
              case 1:
                {
                  Get.back();
                }
                break;
              case 2:
                {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Person person = Person(
                      id: _personController.people.length + 1,
                      name: _personController.newPerson[name],
                      phoneNumber:
                          _personController.newPerson[personPhone] ?? '',
                      address: _personController.newPerson[personAddress] ?? '',
                      type: 'عميل',
                      paid: 0,
                      owned: 0,
                    );
                    _dataBaseServices.addPerson(person);
                    _personController.newPerson.clear();
                    Get.back();
                  }
                }
                break;
              case 3:
                {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _dataBaseServices.addProduct(Product(
                      id: productController.products.length + 1,
                      name: productController.newProduct['name'],
                      buyPrice: double.parse(
                          productController.newProduct['buyPrice'] ?? '0.0'),
                      cellPrice: double.parse(
                          productController.newProduct['cellPrice'] ?? '0.0'),
                      quantity: int.parse(
                          productController.newProduct['quantity'] ?? '0'),
                      lastPrice:
                          productController.newProduct['lastPrice'] ?? 0.0,
                    ));
                    productController.newProduct.clear();
                    Get.back();
                  }
                }
                break;
              case 4:
                {
                  addingProductToBill(true, context);
                }
                break;
              case 5:
                {
                  addingProductToBill(false, context);
                }
                break;
              case 6:
                {
                  addingProductAfterValidation(true);
                }
                break;
              case 9:
                {
                  addingProductToExistingBill(isCelling, context);
                }
                break;
              default:
                {
                  Get.back();
                }
                break;
            }
          },
          child: const Text('حسنا'),
        ),
      ],
    );
  }

  _buildAlertDialogBody(int i) {
    switch (i) {
      case 1:
        {
          return _buildAlertDialogText();
        }
      case 2:
        {
          return _buildPersonAlertDialogForm(
            'تسجيل عميل جديد',
          );
        }
      case 3:
        {
          return _buildProductAlertDialogForm(
            'تسجيل صنف جديد',
          );
        }
      case 4:
        {
          return _buildTextFormField(true);
        }
      case 5:
        {
          return _buildTextFormField(false);
        }
      case 6:
        {
          return const Text(
            'سعر البيع اقل من سعر الشراء',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      case 7:
        {
          return CustomTypeAheadPerson(
            typeAheadController: typeAheadPersonController,
            billController: billController,
            isBill: false,
            isEnabled: true,
          );
        }
      case 8:
        {
          return CustomTypeAheadProduct(
              typeAheadController: typeAheadPersonController,
              productController: productController,
              billController: billController,
              isCelling: isCelling);
        }
      case 9:
        {
          return _buildTextFormField(isCelling);
        }
      default:
        {
          return const SizedBox();
        }
    }
  }

  _buildAlertDialogText() {
    return Text(
      _actionTitles[index],
      textDirection: TextDirection.rtl,
      style: TextStyle(
        color: color,
        fontSize: 14,
      ),
    );
  }

  _buildPersonAlertDialogForm(String title) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            CustomTextFormField(
              controller: nameTextEditingController,
              data: name,
              hintText: 'اسم العميل',
              textInputType: TextInputType.name,
              value: _personController.newPerson[name] ?? '',
              validatorHint: 'من فضلك قم يإدخال اسم العميل',
              iconData: Icons.person,
              textMaxLength: 25,
              onChanged: (value) {
                storingPersonValue(value, name);
              },
            ),
            CustomTextField(
              controller: addressTextEditingController,
              value: '',
              data: personAddress,
              hintText: 'العنوان',
              textInputType: TextInputType.name,
              iconData: Icons.location_city,
              onChanged: (value) {
                storingPersonValue(value, personAddress);
              },
            ),
            CustomTextField(
              controller: phoneTextEditingController,
              value: '',
              data: personPhone,
              hintText: 'رقم الهاتف',
              textInputType: TextInputType.phone,
              iconData: Icons.phone,
              onChanged: (value) {
                storingPersonValue(value, personPhone);
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildProductAlertDialogForm(
    String title,
  ) {
    nameTextEditingController?.value = 'ss' as TextEditingValue;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            CustomTextFormField(
              controller: nameTextEditingController,
              data: name,
              hintText: 'اسم الصنف',
              value: productController.newProduct['name'] ?? '',
              textInputType: TextInputType.name,
              validatorHint: 'من فضلك قم يإدخال اسم الصنف',
              iconData: Icons.person,
              textMaxLength: 25,
              onChanged: (value) {
                storingProductValue(value, name);
              },
            ),
            CustomTextField(
              controller: phoneTextEditingController,
              data: 'cellPrice',
              value: '',
              hintText: 'سعر الشراء',
              textInputType: TextInputType.number,
              iconData: Icons.money,
              onChanged: (value) {
                storingProductValue(value, 'cellPrice');
              },
            ),
            CustomTextField(
              controller: addressTextEditingController,
              data: 'buyPrice',
              value: '',
              hintText: 'سعر البيع',
              textInputType: TextInputType.number,
              iconData: Icons.money,
              // textMaxLength: 4,
              onChanged: (value) {
                storingProductValue(value, 'buyPrice');
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildTextFormField(bool isCelling) {
    String v = isCelling
        ? billController.product['billCellPrice'].toString()
        : billController.product['billBuyPrice'].toString();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('الكمية : ${billController.product['quantity'].toString()}'),
              const Text(' - '),
              Text(isCelling
                  ? ' م سعر الشراء: ${billController.product['buyPrice'].toString()}'
                  : 'اخر سعر شراء: ${billController.product['lastPrice'].toString()}'),
            ],
          ),
        ),
        CustomTextFormField(
          controller: nameTextEditingController,
          data: 'price',
          hintText: isCelling ? 'سعر البيع' : 'سعر الشراء',
          textInputType: TextInputType.number,
          validatorHint:
              isCelling ? 'يجب إدخال سعر البيع' : 'يجب إدخال سعر الشراء',
          iconData: Icons.money,
          textMaxLength: 5,
          onChanged: (value) {
            updatingProductInfo(
                isCelling ? 'billCellPrice' : 'billBuyPrice', value);
            int i = int.parse(billController.product['billQuantity']) *
                int.parse(billController
                    .product[isCelling ? 'billCellPrice' : 'billBuyPrice']);
            updatingProductInfo('total', i.toString());
          },
        ),
        CustomTextFormField(
          controller: phoneTextEditingController,
          data: 'quantity',
          hintText: 'الكمية',
          textInputType: TextInputType.number,
          validatorHint: 'يجب ادخال الكمية',
          iconData: Icons.add_shopping_cart,
          textMaxLength: 5,
          onChanged: (value) {
            updatingProductInfo('billQuantity', value);
            double i = double.parse(billController.product['billQuantity']) *
                double.parse(billController
                    .product[isCelling ? 'billCellPrice' : 'billBuyPrice']);
            updatingProductInfo('total', i.toString());
          },
        ),
      ],
    );
  }

  storingPersonValue(String value, String data) {
    _personController.newPerson.update(
      data,
      (_) => value,
      ifAbsent: () => value,
    );
  }

  storingProductValue(String value, String data) {
    productController.newProduct.update(
      data,
      (_) => value,
      ifAbsent: () => value,
    );
  }

  updatingProductInfo(String data, String value) {
    billController.product.update(
      data,
      (_) => value,
      ifAbsent: () => value,
    );
  }

  addingProductToExistingBill(
    bool isCelling,
    BuildContext context,
  ) {
    if (billController.product.isNotEmpty) {
      if (int.parse(billController.product['billQuantity']) >
          int.parse(billController.product['quantity']) &&
          isCelling) {
        Tasks().showErrorMessage('', 'غير متاح بالمخزن');
      } else if (int.parse(billController.product['billQuantity']) >= 1) {
        if (isCelling &&
            double.parse(billController.product['billCellPrice']) <
                double.parse(billController.product['buyPrice'])) {
          Get.back();
          Tasks().showAction(
            context,
            6,
            false,
          );
        } else if (double.parse(billController
            .product[isCelling ? 'billCellPrice' : 'billBuyPrice']) <
            1) {
          Tasks().showErrorMessage('', 'من فضلك ادخل سعر صحيح');
        } else {
          // _dataBaseServices.addBillProducts(product, isCelling, billID)
          //TODO adding Product to database from here
        }
      } else {
        Tasks().showErrorMessage('', 'من فضلك ادخل كمية صحيحة');
      }
    } else {
      Tasks().showErrorMessage('', 'من فضلك اختار صنف');
    }
  }

  addingProductToBill(
    bool isCelling,
    BuildContext context,
  ) {
    if (billController.product.isNotEmpty) {
      if (int.parse(billController.product['billQuantity']) >
              int.parse(billController.product['quantity']) &&
          isCelling) {
        Tasks().showErrorMessage('', 'غير متاح بالمخزن');
      } else if (int.parse(billController.product['billQuantity']) >= 1) {
        if (isCelling &&
            double.parse(billController.product['billCellPrice']) <
                double.parse(billController.product['buyPrice'])) {
          Get.back();
          Tasks().showAction(
            context,
            6,
            false,
          );
        } else if (double.parse(billController
                .product[isCelling ? 'billCellPrice' : 'billBuyPrice']) <
            1) {
          Tasks().showErrorMessage('', 'من فضلك ادخل سعر صحيح');
        } else {
          addingProductAfterValidation(isCelling);
        }
      } else {
        Tasks().showErrorMessage('', 'من فضلك ادخل كمية صحيحة');
      }
    } else {
      Tasks().showErrorMessage('', 'من فضلك اختار صنف');
    }
  }

  addingProductAfterValidation(bool isCelling) {
    billController.addProduct.add(
      Product(
        id: billController.product['id'] ?? 0,
        name: billController.product['name'] ?? '',
        buyPrice: isCelling
            ? double.parse(billController.product['buyPrice'] ?? '0.0')
            : double.parse(billController.product['buyPrice'] ?? '0.0'),
        cellPrice: isCelling
            ? double.parse(billController.product['billCellPrice'] ?? '0.0')
            : double.parse(billController.product['billBuyPrice'] ?? '0.0'),
        quantity: int.parse(billController.product['billQuantity'] ?? '0'),
        lastPrice: double.parse(billController.product['lastPrice'] ?? '0.0'),
      ),
    );
    _dataBaseServices.updateProductAveragePrice(
        billController.product['id'],
        int.parse(billController.product['quantity'] ?? '0'),
        double.parse(billController.product['buyPrice'] ?? '0'),
        int.parse(billController.product['billQuantity'] ?? '0'),
        double.parse(billController.product['billBuyPrice'] ?? '0'),
        isCelling);
    Get.back();
    billController.updatingBillTotal();
    billController.product.clear();
    phoneTextEditingController.clear();
    nameTextEditingController?.clear();
  }
}
