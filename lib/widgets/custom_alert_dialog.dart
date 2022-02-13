import 'package:cashier/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialog extends StatelessWidget {
  CustomAlertDialog({
    Key? key,
    this.color,
    required this.index,
  }) : super(key: key);

  static const _actionTitles = [
    'إضافة شخص',
    'إضافة صنف',
    'إضافة فاتورة',
    'اختار نوع النقدية',
    'رقم هاتف غير صحيح'
  ];
  final int index;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        _actionTitles[index],
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: color,
          fontSize: 14,
        ),
      ),
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
                  Get.back();
                  //Get.to(() => AddBillScreen());
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
}
