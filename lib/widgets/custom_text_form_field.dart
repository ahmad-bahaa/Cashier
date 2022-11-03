import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    required this.data,
    required this.hintText,
    required this.textInputType,
    required this.validatorHint,
    required this.iconData,
    required this.textMaxLength,
    required this.controller,
    this.isEnabled,
    this.value,
    this.onChanged,
  }) : super(key: key);

  final String data;
  final String hintText;
  final TextInputType textInputType;
  final String validatorHint;
  final IconData iconData;
  final int textMaxLength;
  final TextEditingController? controller;
  bool? isEnabled;
  final Function(String)? onChanged;
  String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          enabled: isEnabled,
          controller: controller,
          // initialValue: data,
          maxLines: 1,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            label: Text(hintText),
            labelStyle: const TextStyle(
              color: Colors.blue,
            ),
            filled: true,
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
          // maxLength: textMaxLength,
          validator: (val) => val == null || val.isEmpty ? validatorHint : null,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
