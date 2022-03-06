import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillController extends GetxController{
  DataBaseServices dataBaseServices = DataBaseServices();
  var newBill = {}.obs;
  var bills = <Bill>[].obs;
  var addProduct = <Product>[].obs;
  var product = {}.obs;
  var rows = <TableRow>[].obs;


  @override
  void onInit() {
    bills.bindStream(dataBaseServices.getAllBills());
    super.onInit();
  }
}