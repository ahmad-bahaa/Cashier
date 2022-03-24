import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                if(_key.currentState!.validate()){

                }
              },
              child: Text(
                'تسجيل دخول',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.blue),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/102.png',
                height: 250,
                width: 250,
              ),
              CustomContainer(
                color: Colors.white,
                widget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'تسجل دخول',
                          style: TextStyle(fontSize: 26),
                        ),
                        CustomTextFormField(
                          data: 'data',
                          hintText: 'بريد الكتروني',
                          textInputType: TextInputType.emailAddress,
                          validatorHint: 'من فضلك قم بإدخال بريد الكتروني',
                          iconData: Icons.email,
                          textMaxLength: 20,
                          onChanged: (value) {},
                        ),
                        CustomTextFormField(
                          data: 'data',
                          hintText: 'باسورد',
                          textInputType: TextInputType.visiblePassword,
                          validatorHint: 'من فضلك قم بإدخال رقم سري',
                          iconData: Icons.lock,
                          textMaxLength: 20,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
               SizedBox(height: MediaQuery.of(context).size.height / 4,),
            ],
          ),
        ),
      ),
    );
  }
}
