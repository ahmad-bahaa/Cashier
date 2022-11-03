import 'package:cashier/constants/constansts.dart';
import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cashier/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillController extends GetxController {
  DataBaseServices dataBaseServices = DataBaseServices();
  var newBill = {}.obs;
  var incomingBills = <Bill>[].obs;
  var ongoingBills = <Bill>[].obs;
  var queryBills = <Bill>[].obs;
  var addProduct = <Product>[].obs;
  var product = {}.obs;
  var rows = <TableRow>[].obs;
  RxDouble totalBillPrice = 0.0.obs;
  RxDouble totalBillEarnings = 0.0.obs;

  updatingBillTotal() {
    double productPrice = 0.0;
    double productEarning = 0.0;

    if (addProduct.isNotEmpty) {
      addProduct.forEach((element) {
        productPrice += element.cellPrice * element.quantity;
        productEarning += element.quantity * element.buyPrice;
        totalBillPrice.value =  productPrice;
        totalBillEarnings.value = productPrice - productEarning;
      });
    }
  }

  updatingProductsQuantitys(bool isCelling) {
    if (addProduct.isNotEmpty) {
      addProduct.forEach((element) {
        dataBaseServices.updatessProductQuantity(
            element.id, element.quantity, isCelling);
      });
    }
  }

  @override
  void onInit() {
    incomingBills.bindStream(dataBaseServices.getAllBills('incomingBills'));
    ongoingBills.bindStream(dataBaseServices.getAllBills('ongoingBills'));
    queryBills.bindStream(dataBaseServices.getAllUserBills('ongoingBills', 1));
    super.onInit();
  }
}
