import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final int id;
  final String name;
  final String phoneNumber;
  final String address;
  final String type;
  List<String> bills;
  Person({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.type,
    required this.bills,
  });

  Person copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? address,
    String? type,
    List<String>? bills,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      type: type ?? this.type,
      bills: bills ?? this.bills,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'type': type,
      'bills': bills,
    };
  }

  factory Person.fromSnapShot(DocumentSnapshot snap) {
    return Person(
      id: snap['id']?.toInt() ?? 0,
      name: snap['name'] ?? '',
      phoneNumber: snap['phoneNumber'] ?? '',
      address: snap['address'] ?? '',
      type: snap['type'] ?? '',
      bills: List<String>.from(snap['bills']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) =>
      Person.fromSnapShot(json.decode(source));

  @override
  String toString() {
    return 'Person(id: $id, name: $name, phoneNumber: $phoneNumber, address: $address, type: $type, bills: $bills)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      phoneNumber,
      address,
      type,
      bills,
    ];
  }
}
