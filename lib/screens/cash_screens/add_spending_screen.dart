import 'package:cashier/constants/constansts.dart';
import 'package:cashier/models/cash_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/services/tasks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/cash_controller.dart';
import '../../widgets/widgets.dart';

class ADDSpendingScreen extends StatelessWidget {
  ADDSpendingScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DataBaseServices _dataBaseServices = DataBaseServices();
  final CashController cashController = Get.put(CashController());
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController notesTextEditingController =
      TextEditingController();

  final String name = 'name', description = 'description', money = 'money';

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd ').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل مصروفات نثرية'),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomBottomAppBar(
          buttonText: 'حفظ',
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              double cash = double.parse(cashController.newCash[money] ?? '0.0');
              _dataBaseServices.addCashBill(
                Cash(
                  id: cashController.allSpending.length + 1,
                  uid: 0,
                  money: cash,
                  name: cashController.newCash[name] ?? 'مصروفات',
                  date: DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now()),
                  description: cashController.newCash[description] ?? '',
                ),
                'spending',
              );
              _dataBaseServices.updateCash('spending', cash, false);
              _dataBaseServices.updateCash('money', cash, true);
              cashController.newCash.clear();
              billController.newBill.clear();
              textEditingController.clear();
              Tasks().showSuccessMessage(
                  'عملية ناجحة', 'تم إضافة المصروف إلى قواعد البيانات');
              // Get.offAll(()=> ADDSpendingScreen());
            } else {
              Tasks().showErrorMessage('خطأ', 'من فضلك قم بإدخال المبلغ');
            }
          }),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  formattedDate,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                  ),
                  child: CustomTextField(
                    controller: nameTextEditingController,
                    value: '',
                    data: 'اسم المصروف',
                    hintText: 'اسم المصروف',
                    textInputType: TextInputType.multiline,
                    iconData: Icons.money,
                    textMaxLength: 70,
                    onChanged: (value) {
                      storingValue(value, name);
                    },
                  ),
                ),
                CustomTextFormField(
                  data: 'القيمة',
                  hintText: 'قيمة المصروفات',
                  controller: textEditingController,
                  textInputType: TextInputType.number,
                  iconData: Icons.money,
                  validatorHint: 'يجب إدخال قيمة للنقدية',
                  textMaxLength: 5,
                  onChanged: (value) {
                    storingValue(value, money);
                  },
                ),
                CustomTextField(
                  controller: notesTextEditingController,
                  value: '',
                  data: 'الملاحظات',
                  hintText: 'ملاحظات',
                  textInputType: TextInputType.multiline,
                  iconData: Icons.money,
                  textMaxLength: 70,
                  onChanged: (value) {
                    storingValue(value, description);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  storingValue(String value, String data) {
    cashController.newCash.update(
      data,
      (_) => value,
      ifAbsent: () => value,
    );
  }
}
