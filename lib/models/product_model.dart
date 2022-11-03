import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final double buyPrice;
  final double cellPrice;
  final double lastPrice;
  final int quantity;
  Product({
    required this.id,
    required this.name,
    required this.buyPrice,
    required this.cellPrice,
    required this.lastPrice,
    required this.quantity,
  });

  Product copyWith({
    int? id,
    String? name,
    double? buyPrice,
    double? cellPrice,
    int? quantity,
    double? lastPrice,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      buyPrice: buyPrice ?? this.buyPrice,
      cellPrice: cellPrice ?? this.cellPrice,
      quantity: quantity ?? this.quantity,
      lastPrice: lastPrice ?? this.lastPrice
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'buyPrice': buyPrice,
      'cellPrice': cellPrice,
      'quantity': quantity,
      'lastPrice': lastPrice,
    };
  }

  factory Product.fromSnapShot(DocumentSnapshot map) {
    return Product(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      buyPrice: map['buyPrice'].toDouble() ?? 0.0,
      cellPrice: map['cellPrice'].toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
      lastPrice: map['lastPrice'].toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromSnapShot(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, name: $name, buyPrice: $buyPrice, cellPrice: $cellPrice, quantity: $quantity, lastPrice: $lastPrice)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      buyPrice,
      cellPrice,
      quantity,
      lastPrice
    ];
  }
}
