import 'package:cashier/controllers/bill_controller.dart';
import 'package:cashier/controllers/cash_controller.dart';
import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/models/cash_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cashier/services/tasks.dart';
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

  final CashController cashController = Get.put(CashController());
  final BillController billController = Get.put(BillController());
  final PersonController personController = Get.put(PersonController());
  final TextEditingController typeAheadPersonController =
      TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController notesTextEditingController =
      TextEditingController();

  final DataBaseServices _dataBaseServices = DataBaseServices();
  String name = 'name', description = 'description', money = 'money';
  DateTime dateTime = DateTime.now();
  bool _cash = false;
  late bool _isSending;
  late bool isEnabled;

  @override
  Widget build(BuildContext context) {
    cash != null ? isEnabled = false : isEnabled = true;
    if (cash != null) {
      typeAheadPersonController.text = cash!.name.toString();
      textEditingController.text = cash!.money.toString();
      notesTextEditingController.text = cash!.description.toString();
    }

    if (isSending != null) {
      _isSending = isSending!;
    }
    if (cash != null) {
      _cash = true;
    }
    String formattedDate = DateFormat('yyyy-MM-dd ').format(dateTime);
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isSending ? 'دفع نقدية' : 'استلام نقدية',
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: CustomBottomAppBar(
          buttonText: isEnabled ? 'حفظ' : 'null',
          onPressed: () async {
            validateCash(context);
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: CustomTypeAheadPerson(
                      typeAheadController: typeAheadPersonController,
                      billController: billController,
                      isBill: true,
                      isEnabled: isEnabled,
                    ),
                  ),
                  CustomTextFormField(
                    data: money,
                    value: cash?.money.toString() ?? '',
                    controller: textEditingController,
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
                    controller: notesTextEditingController,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  validateCash(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (billController.newBill.isNotEmpty) {
        final q = personController.people.where((p0) {
          return p0.id.isEqual(billController.newBill['personId']);
        }).toList();
        if (_isSending != null && _isSending) {
          int id = cashController.allSending.length + 1;
          _dataBaseServices.addCashBill(
            Cash(
              id: id,
              uid: billController.newBill['uid'] ?? 0,
              money: double.parse(cashController.newCash[money]),
              name: billController.newBill[name] ?? '',
              date: DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now()),
              description: cashController.newCash[description] ?? '',
            ),
            'sending',
          );
          //TODO : what to do when sending money ?
          // _dataBaseServices.updatePersonCash(q[0].id, q[0].paid,
          //     int.parse(cashController.newCash[money]), 'paid');
          _dataBaseServices.updateCash(
              'money', double.parse(cashController.newCash[money]), _isSending);

          cashController.newCash.clear();
          billController.newBill.clear();
          typeAheadPersonController.clear();
          textEditingController.clear();
          Tasks().showSuccessMessage('', 'تم إاضافة نقدية إلى قاعدة البيانات');
        } else if (_isSending != null && !_isSending) {
          int id = cashController.allReceiving.length + 1;
          _dataBaseServices.addCashBill(
            Cash(
              id: id,
              uid: billController.newBill['uid'] ?? 0,
              money: double.parse(cashController.newCash[money]),
              name: billController.newBill[name] ?? '',
              date: DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now()),
              description: cashController.newCash[description] ?? '',
            ),
            'receiving',
          );

          _dataBaseServices.updatePersonCash(q[0].id, q[0].paid.toDouble(),
              double.parse(cashController.newCash[money]), 'paid');
          _dataBaseServices.updateCash(
              'money', double.parse(cashController.newCash[money]), _isSending);
          cashController.newCash.clear();
          billController.newBill.clear();
          typeAheadPersonController.clear();
          textEditingController.clear();
          Tasks().showSuccessMessage('', 'تم إاضافة نقدية إلى قاعدة البيانات');
        } else {
          _showAction(
            context,
            5,
          );
        }
      } else {
        Tasks().showErrorMessage(
          'Error',
          'من فضلك اختار عميل',
        );
      }
    }
  }

  Future<bool> _onWillPop(
    BuildContext context,
  ) async {
    if (billController.newBill.isNotEmpty) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('يوجد نقدية'),
          content: const Text('هل تريد الحفظ ؟'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('لا'),
            ),
            TextButton(
              onPressed: () {
                validateCash(context);
                Navigator.of(context).pop(true);
              },
              child: const Text('نعم'),
            ),
          ],
        ),
      );
    } else {
      return true;
    }
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
