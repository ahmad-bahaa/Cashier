import 'package:cashier/services/database_services.dart';
import 'package:cashier/services/tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../screens/screens.dart';

class AuthController extends GetxController {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    super.onInit();

    firebaseUser = Rx<User?>(firebaseAuth.currentUser);

    firebaseUser.bindStream(firebaseAuth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => SplashScreen());
    }
  }

  Future<void> createUser(String email, String password) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((value) =>
              DataBaseServices().creatingNewUser(value.user!.uid.toString()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Tasks().showErrorMessage('خطأ', 'كلمة مرور ضعيفة جدا.');
      } else if (e.code == 'email-already-in-use') {
        Tasks().showErrorMessage('خطأ', 'يوجد مستخدم بهذا البريد الالكتروني.');
      } else if (e.code == 'invalid-email') {
        Tasks().showErrorMessage('خطأ', 'برجاء إدخال بريد الكتروني صحيح.');
      }
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Tasks()
            .showErrorMessage('خطأ', 'لا يوجد مستخدم بهذا البريد الالكتروني.');
      } else if (e.code == 'wrong-password') {
        Tasks().showErrorMessage('خطأ', ' كلمة مرور خاطئة لهذا المستخدم.');
      } else if (e.code == 'invalid-email') {
        Tasks().showErrorMessage('خطأ', 'برجاء إدخال بريد الكتروني صحيح.');
      } else {
        Tasks().showErrorMessage('خطأ', e.code);
      }
    }
  }

  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
