import 'package:cashier/controllers/person_controller.dart';
import 'package:cashier/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    required this.data,
    required this.hintText,
    required this.textInputType,
    required this.iconData,
    required this.textMaxLength,
    required this.onChanged,
    required this.controller,
    this.value,
    this.isEnabled,
  }) : super(key: key);
  final String data;
  final String hintText;
  final TextInputType textInputType;
  final IconData iconData;
  final Function(String)? onChanged;
  final int textMaxLength;
  final TextEditingController controller;
  String? value;
  bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    controller.text = value!;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          enabled: isEnabled,
          controller: controller,
          maxLines: 1,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            filled: true,
            label: Text(hintText),
            labelStyle: const TextStyle(
              color: Colors.blue,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            prefixIcon: IconTheme(
              data: IconThemeData(
                color: Theme.of(context).primaryColor,
              ),
              child: Icon(iconData),
            ),
          ),
          keyboardType: textInputType,
          maxLength: textMaxLength,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
