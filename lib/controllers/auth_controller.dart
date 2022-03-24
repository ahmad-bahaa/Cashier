import 'package:get/get.dart';

class AuthController extends GetxController {
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // var auth = {}.obs;
  // var currentUser = FirebaseAuth.instance.currentUser;
  // String? get uid {
  //   if (currentUser != null) {
  //     return currentUser?.uid;
  //   }
  // }
  //
  // // Rx<User?> user = Rx<User>();
  // // String? get uid => user.value?.uid;
  //
  // @override
  // void onInit() {
  //   // user.bindStream(firebaseAuth.authStateChanges());
  // }
  //
  // Future<void> createUser(String email, String password) async {
  //   try {
  //     await firebaseAuth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // Future<void> loginUser(String email, String password) async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }
  //
  // Future<void> signOutUser() async {
  //   await FirebaseAuth.instance.signOut();
  // }
}
