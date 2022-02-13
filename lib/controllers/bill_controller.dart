import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:get/get.dart';

class BillController extends GetxController{
  DataBaseServices dataBaseServices = DataBaseServices();
  var newBill = {}.obs;
  var bills = <Bill>[].obs;
  var product = {}.obs;

  @override
  void onInit() {
    bills.bindStream(dataBaseServices.getAllBills());
    super.onInit();
  }
}