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
        .collection('people')
        .orderBy('id', descending: false)
        .get()
        .then((value) =>
            value.docs.map((e) => Person.fromSnapShot(e)).where((element) {
              final user = element.name.toLowerCase();
              final finalQuery = query.toLowerCase();

              return user.contains(finalQuery);
            }).toList());
  }

  Future<List<Product>> queryAllProducts(String query) async {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('products')
        .orderBy('id', descending: false)
        .get()
        .then((value) =>
            value.docs.map((e) => Product.fromSnapShot(e)).where((element) {
              final item = element.name.toLowerCase();
              final finalQuery = query.toLowerCase();

              return item.contains(finalQuery);
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

  Stream<List<Bill>> getAllBills(String billType) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection(billType)
        .orderBy('id', descending: true)
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

//TODO: we didn't use this FYI
  Stream<String> getCash() {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .snapshots()
        .map((event) {
      String value = event.data()!['money'].toString();
      return value;
    });
  }

  Future<void> addPerson(Person person) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('people')
        .add(person.toMap());
  }

  Future<void> addBill(Bill bill, String billType) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection(billType)
        .add(bill.toMap());
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

  Future<void> updateCash(int cash, bool isSending) {
    int totalCash;
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .get()
        .then((value) {
      if (value.exists) {
        totalCash = value.data()!['money'];
        return _firebaseFirestore
            .collection('users')
            .doc(userUid)
            .update({'money': isSending ? totalCash - cash : totalCash + cash})
            .then((value) => print("Cash Updated"))
            .catchError((error) => print("Failed to update Cash: $error"));
      } else {
        print('no Value');
        return null;
      }
    });
  }

  //TODO: remove this "isOngoing" and complete the update
  Future<void> updateProductQuantity(int id, int quantity, bool isOngoing) {
    int totalQuantity;
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('products')
        .snapshots().firstWhere((element) => isOngoing);
  }
}
