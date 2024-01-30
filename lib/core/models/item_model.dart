import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String name;
  final String description;
  final String imageLink;
  final String storeId;

  const Item({
    required this.name,
    required this.description,
    required this.imageLink,
    required this.storeId
  });

  @override
  List<Object?> get props => [name, description, imageLink, storeId];

  factory Item.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Item(
      name: data?['name'],
      description: data?['description'],
      imageLink: data?['imageLink'],
      storeId: data?['storeId']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "id": name,
      if (description != null) "description": description,
      if (imageLink != null) "expireDate": imageLink,
      if (storeId != null) "storeId": storeId
    };
  }

  Item.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        imageLink = json['imageLink'],
        storeId = json['storeId'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'imageLink': imageLink,
    'storeId': storeId
  };
}