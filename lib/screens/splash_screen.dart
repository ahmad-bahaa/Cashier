import 'dart:async';

import 'package:cashier/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 4), () => Get.off(() => const HomeScreen()));
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'logo',
          child: Center(
            child: Image.asset(
              'assets/images/logo-placeholder.png',
              height: 250,
              width: 250,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Center(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'App Name',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    ));
  }
}
