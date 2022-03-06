import 'package:cashier/models/cash_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CashController extends GetxController {
  DataBaseServices dataBaseServices = DataBaseServices();
  var newCash = {}.obs;
  var allSending = <Cash>[].obs;
  var allReceiving = <Cash>[].obs;

  String selectedGender = '';
  final List<String> gender = ['receiving', 'sending'];

  String select = '';

  void onClickRadioButton(value) {
    select = value;
    newCash['cash_type'] = value;
    update();
  }

  @override
  void onInit() {
    allSending.bindStream(dataBaseServices.getAllCashBills('sending'));
    allReceiving.bindStream(dataBaseServices.getAllCashBills('receiving'));
    super.onInit();
  }
}
