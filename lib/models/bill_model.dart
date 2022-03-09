import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:cashier/models/product_model.dart';

class Bill extends Equatable {
  final int id;
  final String name;
  final int price;
  final String date;
  final List<Product> products;

  Bill({
    required this.id,
    required this.name,
    required this.price,
    required this.date,
    required this.products,
  });

  Bill copyWith({
    int? id,
    String? name,
    int? price,
    String? date,
    List<Product>? products,
  }) {
    return Bill(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      date: date ?? this.date,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'date': date,
      'products': products.map((x) => x.toMap()).toList(),
    };
  }


  factory Bill.fromSnapShot(DocumentSnapshot snap) {
    return Bill(
      id: snap['id']?.toInt() ?? 0,
      name: snap['name'] ?? '',
      price: snap['price']?.toInt() ?? 0,
      date: snap['date'] ?? '',
      //TODO: fix the list of products
      products: List<Product>.from(
          snap['products']?.map((x) => Product.fromSnapShot(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bill.fromJson(String source) =>
      Bill.fromSnapShot(json.decode(source));

  @override
  String toString() {
    return 'Bill(id: $id, name: $name, price: $price, date: $date, products: $products)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      price,
      date,
      products,
    ];
  }
}
