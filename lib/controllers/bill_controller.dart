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
  var addProduct = <Product>[].obs;
  var product = {}.obs;
  var rows = <TableRow>[].obs;
  RxInt totalBillPrice = 0.obs;

  updatingBillTotal() {
    totalBillPrice.value = 0;
    if (addProduct.isNotEmpty) {
      addProduct.forEach((element) {
        totalBillPrice += element.buyPrice;
      });
    }
  }

  updatingProductsQuantity(bool isOngoing) {
    if (addProduct.isNotEmpty) {
      addProduct.forEach((element) {
        dataBaseServices.updateProductQuantity(element.id, element.quantity, isOngoing);
      });
      //   var sorce = productController.products.firstWhere((e) {});
      //   firstwhere((e) {
      //     final i = e.id;
      //     return i.isEqual(element.id);
      //   }) as Product;
      //   dataBaseServices.updateProduct(
      //       element.id, sorce.quantity, element.quantity, isOngoing);
      // });
    }
  }

  @override
  void onInit() {
    incomingBills.bindStream(dataBaseServices.getAllBills('incomingBills'));
    ongoingBills.bindStream(dataBaseServices.getAllBills('ongoingBills'));
    super.onInit();
  }
}
