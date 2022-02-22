import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialog extends StatelessWidget {
  CustomAlertDialog({
    Key? key,
    required this.color,
    required this.index,
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
  final DataBaseServices _dataBaseServices = DataBaseServices();

  String personName = 'name';
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
                    _dataBaseServices.addPerson(Person(
                      id: _personController.people.length + 1,
                      name: _personController.newPerson[personName],
                      phoneNumber:
                          _personController.newPerson[personPhone] ?? '',
                      address: _personController.newPerson[personAddress] ?? '',
                      type: 'عميل',
                      bills: const [],
                    ));
                  }
                }
                break;
              case 3:
                {
                  Get.back();
                }
                break;
              case 4:
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
          return _buildAlertDialogForm();
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

  _buildAlertDialogForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'تسجيل عميل جديد',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            CustomTextFormField(
              data: personName,
              hintText: 'اسم العميل',
              textInputType: TextInputType.name,
              validatorHint: 'من فضلك قم يإدخال اسم العميل',
              iconData: Icons.person,
              textMaxLength: 25,
              onChanged: (value) {
                storingValue(value, personName);
              },
            ),
            CustomTextField(
              data: personAddress,
              hintText: 'العنوان',
              textInputType: TextInputType.name,
              iconData: Icons.location_city,
              textMaxLength: 25,
              onChanged: (value) {
                storingValue(value, personAddress);
              },
            ),
            CustomTextField(
              data: personPhone,
              hintText: 'رقم الهاتف',
              textInputType: TextInputType.phone,
              iconData: Icons.phone,
              textMaxLength: 11,
              onChanged: (value) {
                storingValue(value, personPhone);
              },
            ),
          ],
        ),
      ),
    );
  }

  storingValue(String value, String data) {
    _personController.newPerson.update(
      data,
      (_) => value,
      ifAbsent: () => value,
    );
  }
}
