import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Tasks{
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
}