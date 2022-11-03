import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    required this.widget,
    required this.color,

  }) : super(key: key);
  final Widget widget;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0.0, 1.0),
            blurRadius: 1.0,
            blurStyle: BlurStyle.normal,
          ),
        ],
      ),
      child: widget,
    );
  }
}
