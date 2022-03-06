import 'package:cashier/services/tasks.dart';
import 'package:flutter/material.dart';

class BuildNewItem extends StatelessWidget {
  const BuildNewItem({
    Key? key,
    required this.i,
    required this.text,
  }) : super(key: key);
  final int i;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Tasks().showAction(context, i),
      child: SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(text),
              const Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }
}
