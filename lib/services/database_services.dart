import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/cash_model.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class DataBaseServices {
  String userUid = 'ji7k9SxbxfHUqDctJx1W';

  Stream<List<Person>> getAllPeople() {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('people')
        .orderBy('id', descending: false)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Person.fromSnapShot(e)).toList();
    });
  }

  Future<List<Person>> queryAllPeople(String query) async {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('people').orderBy('id',descending: false)
        .get()
        .then((value) =>
            value.docs.map((e) => Person.fromSnapShot(e)).where((element) {
              final user = element.name.toLowerCase();
              final finalQuery = query.toLowerCase();

              return user.contains(finalQuery);
            }).toList());
  }

  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('products')
        .where(
          'quantity',
          isGreaterThan: 0,
        )
        .orderBy('quantity', descending: false)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Product.fromSnapShot(e)).toList();
    });
  }

  Stream<List<Product>> getAllEndedProducts() {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('products')
        .where('quantity', isEqualTo: 0)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Product.fromSnapShot(e)).toList();
    });
  }

  Stream<List<Bill>> getAllBills() {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('bills')
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Bill.fromSnapShot(e)).toList();
    });
  }

  Stream<List<Cash>> getAllCashBills(String cashType) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection(cashType)
        .orderBy('id', descending: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Cash.fromSnapShot(e)).toList();
    });
  }

  //TODO: get cash
  Future getCash() {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .get()
        .then((value) => null);
  }

  Future<void> addPerson(Person person) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('people')
        .add(person.toMap());
  }

  Future<void> addCashBill(Cash cash, String cashType) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection(cashType)
        .add(cash.toMap());
  }

  Future<void> addProduct(Product product) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('products')
        .add(product.toMap());
  }

  Future<void> updateCash(int cash) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .update({'money': cash})
        .then((value) => print("Cash Updated"))
        .catchError((error) => print("Failed to update Cash: $error"));
  }
}
