import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FavoriteStore extends Equatable {
  final String name;
  final String description;
  final String coverImageLink;
  final String storeId;

  const FavoriteStore({
    required this.name,
    required this.description,
    required this.coverImageLink,
    required this.storeId
  });

  @override
  List<Object?> get props => [name, description, storeId, coverImageLink];

  factory FavoriteStore.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return FavoriteStore(
      name: data?['name'],
      description: data?['description'],
      coverImageLink: data?['coverImageLink'],
      storeId: data?['storeId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (coverImageLink != null) "coverImageLink": coverImageLink,
      if (storeId != null) "storeId": storeId,
    };
  }

  FavoriteStore.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        coverImageLink = json['coverImageLink'],
        storeId = json['storeId'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'coverImageLink': coverImageLink,
    'storeId': storeId,
  };
}