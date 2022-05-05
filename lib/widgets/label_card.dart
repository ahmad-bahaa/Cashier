import 'package:cashier/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class LabelCard extends StatelessWidget {
  const LabelCard({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      widget: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 60,
            ),
            Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      color: Colors.blue,
    );
  }
}
