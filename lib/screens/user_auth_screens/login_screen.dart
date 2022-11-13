import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/screens/home_screen.dart';
import 'package:cashier/services/tasks.dart';
import 'package:cashier/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.put(AuthController());

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  bool signIn = true;
  bool isHidden = true;
  late String password, rePassword;
  String email = '';

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
                if (_key.currentState!.validate()) {
                  signIn
                      ? authController.loginUser(email, password)
                      : password == rePassword
                          ? authController.createUser(email, password)
                          : Tasks().showErrorMessage(
                              '', 'برجاء التاكد من تطابق الرقم السري');
                }
              },
              child: Text(
                'تسجيل',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 100,
            ),
            // Image.asset(
            //   'assets/images/102.png',
            //   height: 200,
            //   width: 200,
            // ),
            const Text(
              'كاشير فري',
              style: TextStyle(fontSize: 36),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 30.0,
                  bottom: 8.0,
                  top: 8.0,
                ),
                child: Text(
                  signIn ? 'تسجل دخول' : 'انشئ حساب جديد',
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
            CustomContainer(
              color: Colors.white,
              widget: Padding(
                padding: const EdgeInsets.only(
                    right: 5.0, left: 5.0, bottom: 5.0, top: 32.0),
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        controller: textEditingController,
                        data: 'data',
                        hintText: 'بريد الكتروني',
                        textInputType: TextInputType.emailAddress,
                        validatorHint: 'من فضلك قم بإدخال بريد الكتروني',
                        iconData: Icons.email,
                        textMaxLength: 20,
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          obscureText: isHidden,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'ادخل كلمة السر',
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
                              child: const Icon(Icons.lock),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isHidden = !isHidden;
                                });
                              },
                              icon: Icon(isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          validator: (val) => val == null || val.length < 6
                              ? 'من فضلك قم بإدخال كلمة سر مناسبه'
                              : null,
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      !signIn
                          ? Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                obscureText: isHidden,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: 'ادخل كلمة السر مره اخرى',
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
                                    child: const Icon(Icons.lock),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isHidden = !isHidden;
                                      });
                                    },
                                    icon: Icon(isHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                validator: (val) =>
                                    val == null || val.length < 6
                                        ? 'من فضلك قم بمطابقة الرقم السري'
                                        : null,
                                onChanged: (val) {
                                  rePassword = val;
                                },
                              ),
                            )
                          : const SizedBox(),
                      signIn
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: const Text(
                                  'هل نسيت كلمة السر ؟',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.indigo),
                                ),
                                onTap: () {
                                  if(email.isEmpty){
                                    Tasks().showErrorMessage('', 'من فضلك ادخل بريد الكتروني صحيح');
                                  }else {
                                    Tasks().showHintMessage('', 'من فضلك تحقق من بريدك الالكتروني');
                                    authController.forgotPassword(email);
                                  }
                                },
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
            CustomRichText(
              discription:
                  signIn ? ' لا تمتلك حساب.؟' : ' هل انت مستخدم حالي.؟',
              text: signIn ? " سجل الان " : ' سجل دخول',
              onTap: () {
                //TODO: this should be sign up screen
                setState(() {
                  signIn = !signIn;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
