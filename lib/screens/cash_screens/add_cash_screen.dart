import 'package:cashier/controllers/cash_controller.dart';
import 'package:cashier/models/cash_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddCashScreen extends StatelessWidget {
  AddCashScreen({
    Key? key,
    this.cash,
    this.isSending,
  }) : super(key: key);
  bool? isSending;
  Cash? cash;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CashController cashController = Get.put(CashController());

  final DataBaseServices _dataBaseServices = DataBaseServices();
  String name = 'name',
      description = 'description',
      money = 'money',
      cashType = 'cash_type';
  DateTime dateTime = DateTime.now();
  bool _cash = false;
  late bool _isSending;
  late bool isEnabled;

  @override
  Widget build(BuildContext context) {
    cash != null ? isEnabled = false : isEnabled = true;

    if (isSending != null) {
      _isSending = isSending!;
    }
    if (cash != null) {
      _cash = true;
    }
    String formattedDate = DateFormat('yyyy-MM-dd ').format(dateTime);
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل نقدية جديدة'),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomBottomAppBar(
        buttonText: 'حفظ',
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_isSending != null && _isSending) {
              int id = cashController.allSending.length + 1;
              _dataBaseServices.addCashBill(
                Cash(
                  id: id,
                  money: int.parse(cashController.newCash[money]),
                  name: cashController.newCash[name] ?? '',
                  date: DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now()),
                  description: cashController.newCash[description] ?? '',
                ),
                'sending',
              );
              _dataBaseServices.updateCash(
                  int.parse(cashController.newCash[money]), _isSending);
              Get.back();
            } else if (_isSending != null && !_isSending) {
              int id = cashController.allReceiving.length + 1;
              _dataBaseServices.addCashBill(
                Cash(
                  id: id,
                  money: int.parse(cashController.newCash[money]),
                  name: cashController.newCash[name] ?? '',
                  date: DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now()),
                  description: cashController.newCash[description] ?? '',
                ),
                'receiving',
              );
              _dataBaseServices.updateCash(
                  int.parse(cashController.newCash[money]), _isSending);
              Get.back();
            } else {
              _showAction(
                context,
                3,
              );
            }
          }
        },
      ),
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
                CustomTextFormField(
                  data: name,
                  value: cash?.name ?? '',
                  isEnabled: isEnabled,
                  hintText: 'إسم النقدية ',
                  textInputType: TextInputType.name,
                  iconData: Icons.person,
                  validatorHint: 'يجب إدخال اسم للنقدية',
                  textMaxLength: 25,
                  onChanged: (value) {
                    storingValue(value, name);
                  },
                ),
                CustomTextFormField(
                  data: money,
                  value: cash?.money.toString() ?? '',
                  isEnabled: isEnabled,
                  hintText: 'قيمة النقدية',
                  textInputType: TextInputType.number,
                  iconData: Icons.money,
                  validatorHint: 'يجب إدخال قيمة للنقدية',
                  textMaxLength: 5,
                  onChanged: (value) {
                    storingValue(value, money);
                  },
                ),
                CustomTextField(
                  data: description,
                  value: cash?.description ?? '',
                  isEnabled: isEnabled,
                  hintText: 'ملاحظات',
                  textInputType: TextInputType.multiline,
                  iconData: Icons.money,
                  textMaxLength: 70,
                  onChanged: (value) {
                    storingValue(value, description);
                  },
                ),
                const Text(
                  'نوع النقدية',
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
                Center(
                  child: Text(
                    _isSending ? 'دفع نقدية' : 'استلام نقدية',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: _isSending ? Colors.red : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addRadioButton(
      BuildContext context, int btnIndex, String title, Color color) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 10,
      child: ListTile(
        trailing: GetBuilder<CashController>(
          builder: (_) => Radio(
              activeColor: Colors.blue,
              value: cashController.gender[btnIndex],
              groupValue: cashController.select,
              onChanged: (value) => cashController.onClickRadioButton(value)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
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
