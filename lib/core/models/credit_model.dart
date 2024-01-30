import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Credit extends Equatable {
  final String id;
  final Timestamp expireDate;
  final String storeId;
  final double amtOff;
  final String storeName;
  final String coverImageLink;

  const Credit({
    required this.id,
    required this.expireDate,
    required this.storeId,
    required this.amtOff,
    required this.coverImageLink,
    required this.storeName
  });

  @override
  List<Object?> get props => [id, expireDate, storeId, amtOff, coverImageLink, storeName];

  Credit.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        expireDate = json['expireDate'],
        storeId = json['storeId'],
        coverImageLink = json['coverImageLink'],
        amtOff = json['amtOff'],
        storeName = json['storeName'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'expireDate': expireDate,
    'storeId': storeId,
    'coverImageLink': coverImageLink,
    'amtOff': amtOff,
    'storeName': storeName
  };

  factory Credit.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Credit(
      id: data?['id'],
      expireDate: data?['expireDate'],
      storeId: data?['storeId'],
      coverImageLink: data?['coverImageLink'],
      amtOff: data?['amtOff'],
      storeName: data?['storeName']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (expireDate != null) "expireDate": expireDate,
      if (storeId != null) "storeId": storeId,
      if (coverImageLink != null) "coverImageLink": coverImageLink,
      if (amtOff != null) "amtOff": amtOff,
      if (storeName != null) "storeName": storeName
    };
  }
}