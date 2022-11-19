import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('سياسة الخصوصية'),
      ),
      body: Center(
        child: Image.asset(
          'assets/images/privacy.jpg',
        ),
      ),
    );
  }
}
