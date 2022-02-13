import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:cashier/models/product_model.dart';

class Bill extends Equatable {
  final int id;
  final String name;
  final List<Product> products;
  final DateTime dateTime;

  Bill({
    required this.id,
    required this.name,
    required this.products,
    required this.dateTime,
  });

  Bill copyWith({
    int? id,
    String? name,
    List<Product>? products,
    DateTime? dateTime,
  }) {
    return Bill(
      id: id ?? this.id,
      name: name ?? this.name,
      products: products ?? this.products,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'products': products.map((x) => x.toMap()).toList(),
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory Bill.fromSnapShot(DocumentSnapshot map) {
    return Bill(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      products:
          List<Product>.from(map['products']?.map((x) => Product.fromSnapShot(x))),
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bill.fromJson(String source) => Bill.fromSnapShot(json.decode(source));

  @override
  String toString() {
    return 'Bill(id: $id, name: $name, products: $products, dateTime: $dateTime)';
  }

  @override
  List<Object> get props => [id, name, products, dateTime];
}
