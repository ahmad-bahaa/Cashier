import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialog extends StatelessWidget {
  CustomAlertDialog({
    Key? key,
    required this.color,
    required this.index,
    this.textEditingController,
  }) : super(key: key);

  static const _actionTitles = [
    'رقم هاتف غير صحيح',
    'إضافة صنف',
    'إضافة فاتورة',
  ];
  final int index;
  final Color color;
  final _formKey = GlobalKey<FormState>();
  final PersonController _personController = Get.put(PersonController());
  final ProductController productController = Get.put(ProductController());
  final BillController billController = Get.put(BillController());
  final DataBaseServices _dataBaseServices = DataBaseServices();
  final TextEditingController? textEditingController;

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
                      bills: const [],
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
                      buyPrice: int.parse(
                          productController.newProduct['buyPrice'] ?? '0'),
                      cellPrice: int.parse(
                          productController.newProduct['cellPrice'] ?? '0'),
                      quantity: int.parse(
                          productController.newProduct['quantity'] ?? '0'),
                    ));
                    productController.newProduct.clear();
                    Get.back();
                  }
                }
                break;
              case 4:
                {
                  Get.back();
                }
                break;
              case 5:
                {
                  Get.back();
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
            '',
            '',
            '',
          );
        }
      case 3:
        {
          return _buildProductAlertDialogForm(
            'تسجيل صنف جديد',
            '',
            '',
            '',
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

  _buildPersonAlertDialogForm(
      String title, String first, String second, String third) {
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
              data: name,
              hintText: 'اسم العميل',
              textInputType: TextInputType.name,
              value:  _personController.newPerson[name] ?? '',
              validatorHint: 'من فضلك قم يإدخال اسم العميل',
              iconData: Icons.person,
              textMaxLength: 25,
              onChanged: (value) {
                storingPersonValue(value, name);
              },
            ),
            CustomTextField(
              data: personAddress,
              hintText: 'العنوان',
              textInputType: TextInputType.name,
              iconData: Icons.location_city,
              textMaxLength: 25,
              onChanged: (value) {
                storingPersonValue(value, personAddress);
              },
            ),
            CustomTextField(
              data: personPhone,
              hintText: 'رقم الهاتف',
              textInputType: TextInputType.phone,
              iconData: Icons.phone,
              textMaxLength: 11,
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
      String title, String first, String second, String third) {
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
              data: 'cellPrice',
              hintText: 'سعر الشراء',
              textInputType: TextInputType.number,
              iconData: Icons.money,
              textMaxLength: 4,
              onChanged: (value) {
                storingProductValue(value, 'cellPrice');
              },
            ),
            CustomTextField(
              data: 'buyPrice',
              hintText: 'سعر البيع',
              textInputType: TextInputType.number,
              iconData: Icons.money,
              textMaxLength: 4,
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
    String v = isCelling ? billController.product['billCellPrice'].toString() : billController.product['billBuyPrice'].toString();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () => Text( isCelling ?
              'سعر البيع : ${billController.product['cellPrice'].toString()}'
          :  'سعر الشراء : ${billController.product['buyPrice'].toString()}'),
        ),
        CustomTextFormField(
          data: 'price',
          hintText: isCelling ? 'سعر البيع' : 'سعر الشراء',
          textInputType: TextInputType.number,
          validatorHint:   isCelling ? 'يجب إدخال سعر البيع' : 'يجب إدخال سعر الشراء',
          iconData: Icons.person,
          textMaxLength: 5,
          onChanged: (value) {
            updatingProductInfo(isCelling ? 'billCellPrice' : 'billBuyPrice', value);
            int i = int.parse(billController.product['billQuantity']) *
                int.parse(billController.product[isCelling ? 'billCellPrice' : 'billCellPrice']);
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
}
