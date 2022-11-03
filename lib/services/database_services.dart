import 'package:cashier/controllers/auth_controller.dart';
import 'package:cashier/models/bill_model.dart';
import 'package:cashier/models/cash_model.dart';
import 'package:cashier/models/person_model.dart';
import 'package:cashier/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

class DataBaseServices {
  // String userUi = 'ji7k9SxbxfHUqDctJx1W';
  String userUid = AuthController().firebaseAuth.currentUser!.uid.toString();

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

  Stream<List<Bill>> queryBills(String collection, String q) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('ongoingBills')
        .orderBy('id', descending: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Bill.fromSnapShot(e)).where((element) {
              final item = element.name.toLowerCase();
              final query = q.toLowerCase();
              return item.contains('ahmad');
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

  Future<List<Bill>> queryAllBills(String collection, String query) async {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection(collection)
        .orderBy('id', descending: false)
        .get()
        .then((value) =>
            value.docs.map((e) => Bill.fromSnapShot(e)).where((element) {
              final bill = element.name.toLowerCase();
              final finalQuery = query.toLowerCase();

              return bill.contains(finalQuery);
            }).toList());
  }

  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('products')
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Product.fromSnapShot(e)).toList();
    });
  }

  Future<List<Product>> getAllBillProducts(String billType, int billID) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('billsProducts')
        .doc(billType)
        .collection(billID.toString())
        .get()
        .then((value) {
      return value.docs.map((e) => Product.fromSnapShot(e)).toList();
    });
  }

  Stream<List<Product>> getAllActiveProducts() {
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

  Stream<List<Bill>> getAllUserBills(String collection, int uid) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection(collection)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Bill.fromSnapShot(e)).toList();
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
        .map((event) => event.docs
            .map((e) => Cash.fromSnapShot(e))
            // .where((element) => element.name.contains('ahmed'))
            .toList());
  }

//TODO: we didn't use this FYI
  Stream<String> getCash(String data) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .snapshots()
        .map((event) {
      String value = event.data()![data].toString();
      return value;
    });
  }

  Future<void> creatingNewUser(String u) {
    return _firebaseFirestore.collection('users').doc(u).set({
      'money': 0.0,
      'spending': 0.0,
      'celling': 0.0,
      'buying': 0.0,
      'earnings': 0.0,
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

  Future<void> addBillProducts(Product product, String billType, int billID) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('billsProducts')
        .doc(billType)
        .collection(billID.toString())
        .add(product.toMap());
  }

  Future<void> updateCash(String cashType, double cash, bool isSending) {
    double totalCash;
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .get()
        .then((value) {
      if (value.exists) {
        totalCash = double.parse(value.data()![cashType].toString());
        return _firebaseFirestore
            .collection('users')
            .doc(userUid)
            .update({
              if (cashType == 'earnings' && isSending)
                cashType: totalCash + cash,
              if (cashType != 'earnings')
                cashType: isSending ? totalCash - cash : totalCash + cash,
            })
            .then((value) => print("Cash Updated"))
            .catchError((error) => print("Failed to update Cash: $error"));
      } else {
        print('no Value');
        return null;
      }
    });
  }

  //TODO: remove this
  Future<void> updatessProductQuantity(int id, int quantity, bool isCelling) {
    Product product;
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('products')
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      product = value.docs.first.reference
          .get()
          .then((value) => Product.fromSnapShot(value)) as Product;
      value.docs.first.reference.update({
        'quantity': isCelling
            ? product.quantity - quantity
            : product.quantity + quantity
      });
    });
  }

  Future<void> updateProduct(
      int id, int quantity, int billQuantity, bool isOngoing) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('products')
        .where('id', isEqualTo: id)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first.reference.update({
              'quantity':
                  isOngoing ? quantity - billQuantity : quantity + billQuantity
            }));
  }

  Future<void> updateProductAveragePrice(int id, int qty, double buyPrice,
      int billQuantity, double billPrice, bool isOngoing) {
    double oldPrice = buyPrice * qty;
    double allBillPrice = billPrice * billQuantity;
    double allPrices = oldPrice + allBillPrice;
    int allQty = qty + billQuantity;
    double newPrice = allPrices / allQty;

    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('products')
        .where('id', isEqualTo: id)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first.reference.update({
              if (!isOngoing) 'lastPrice': billPrice.toDouble(),
              if (!isOngoing)
                'buyPrice': double.parse(newPrice.toStringAsFixed(2)),
              'quantity': isOngoing ? qty - billQuantity : qty + billQuantity,
            }));
  }

  Future<void> updatePersonInfo(
    String collection,
    int id,
    String dataType,
    String data,
  ) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first.reference.update({
              dataType: data,
            }));
  }

  Future<void> updateProductName(
    String collection,
    int id,
    String dataType,
    String data,
  ) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first.reference.update({
              dataType: data,
            }));
  }

  Future<void> updateProductPrice(
    String collection,
    int id,
    String dataType,
    int data,
  ) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first.reference.update({
              dataType: data,
            }));
  }

  Future<void> updatePersonCash(
    int id,
    double cash,
    double newCash,
    String type,
  ) {
    return _firebaseFirestore
        .collection('users')
        .doc(userUid)
        .collection('people')
        .where('id', isEqualTo: id)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first.reference.update({
              type: cash + newCash,
            }));
  }
}
