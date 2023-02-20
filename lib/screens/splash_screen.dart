import 'dart:async';

import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/screens/screens.dart';
import 'package:cashier/services/tasks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SplashScreen extends StatelessWidget {
  // bool hasInternet = false;
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () async {
        // hasInternet = await InternetConnectionChecker().hasConnection;
        // hasInternet ?
        Get.off(() => HomeScreen());
        // : Tasks().showErrorMessage('', ' لا يوجد انترنت');
      },
    );
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: Center(
                child: Image.asset(
                  'assets/images/logo.jpg',
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
                // color: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Cashier App',
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
