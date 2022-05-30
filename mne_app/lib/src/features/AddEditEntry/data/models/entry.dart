import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/firebase.dart';
import 'chilli.dart';

import 'party.dart';

class Entry extends Equatable {
  String id;
  final DateTime date;
  final Party party;
  final Chilli chilli;
  final num bagCount, serialNum;
  num totalWeight, netWeight, rate;
  List<Map<String, dynamic>> bags;

  Entry.empty({
    this.id = "",
    required this.date,
    this.party = const Party(id: "", name: ""),
    this.chilli = const Chilli(id: "", label: ""),
    this.bagCount = 1,
    this.rate = 0,
    this.serialNum = 1,
    this.totalWeight = 0,
    this.netWeight = 0,
    this.bags = const [],
  });

  Entry.initial({
    this.id = "",
    required this.date,
    required this.party,
    required this.chilli,
    required this.bagCount,
    required this.rate,
    required this.serialNum,
    this.totalWeight = 0,
    this.netWeight = 0,
    this.bags = const [],
  });

  Entry({
    this.id = "",
    required this.date,
    required this.party,
    required this.chilli,
    required this.bagCount,
    required this.rate,
    required this.serialNum,
    required this.totalWeight,
    required this.netWeight,
    this.bags = const [],
  });

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        id: json['id'],
        date: (json['date'] as Timestamp).toDate(),
        party: json['party'] as Party,
        chilli: json['chilli'] as Chilli,
        bagCount: json['bagCount'],
        rate: json['rate'],
        serialNum: json['serialNum'],
        totalWeight: json['totalWeight'],
        netWeight: json['netWeight'],
        bags: (json['bags'] as List<dynamic>)
            .map((bag) => bag as Map<String, dynamic>)
            .toList(),
      );

  @override
  List<Object?> get props => [
        id,
        date,
        party,
        chilli,
        bagCount,
        serialNum,
        totalWeight,
        netWeight,
        bags,
      ];

  Map<String, dynamic> toJson() {
    return {
      "bagCount": bagCount,
      "bags": bags,
      "date": date,
      "mark_id": chilli.id,
      "netWeight": netWeight,
      "party_id": party.id,
      "rate": rate,
      "serialNum": serialNum,
      "totalWeight": totalWeight,
      "user_id": FirebaseInit.auth.currentUser?.uid
    };
  }
}
