import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Cash extends Equatable {
  final int id;
  final int uid;
  final double money;
  final String name;
  final String date;
  final String description;
  const Cash({
    required this.id,
    required this.uid,
    required this.money,
    required this.name,
    required this.date,
    required this.description,
  });

  Cash copyWith({
    int? id,
    int? uid,
    double? money,
    String? name,
    String? date,
    String? description
  }) {
    return Cash(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      money: money ?? this.money,
      name: name ?? this.name,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'money': money,
      'name': name,
      'date': date,
      'description': description,
    };
  }

  factory Cash.fromSnapShot(DocumentSnapshot map) {
    return Cash(
      id: map['id']?.toInt() ?? 0,
        uid: map['uid']?.toInt() ?? 0,
      money: map['money']?.toDouble() ?? 0,
      name: map['name'] ?? '',
      date: map['date']?? '',
      description: map['description']?? '',
    );
  }
  factory Cash.fromSnap(DocumentSnapshot map) {
    return map['money']?.toInt() ?? 0;
  }

  String toJson() => json.encode(toMap());

  factory Cash.fromJson(String source) => Cash.fromSnapShot(json.decode(source));

  @override
  String toString() {
    return 'Cash(id: $id,uid: $uid, money: $money, name: $name, date: $date,description: $description)';
  }

  @override
  List<Object> get props => [id,uid, money, name, date,description];
}