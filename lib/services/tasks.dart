import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tasks {
  void showAction(BuildContext context, int index) {
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

  void showErrorMessage(String title, String message) {
    Get.snackbar(title, message,
        colorText: Colors.red, backgroundColor: Colors.black);
  }

  void showSuccessMessage(String title, String message) {
    Get.snackbar(title, message,
        colorText: Colors.white, backgroundColor: Colors.green);
  }

  void showHintMessage(String title, String message,) {
    Get.snackbar(title, message,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        snackPosition: SnackPosition.TOP,);
  }



}
