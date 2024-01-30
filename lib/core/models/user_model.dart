import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gide/core/models/credit_model.dart';
import 'package:gide/core/models/favorite_store_model.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String? storeId;
  List<Credit>? credits = [];
  List<FavoriteStore>? favoriteStores = [];
  final Timestamp lastModified;

  User({
    required this.id,
    required this.username,
    this.storeId,
    required this.credits,
    required this.favoriteStores,
    required this.lastModified
  });

  @override
  List<Object?> get props => [id, username, storeId, credits, favoriteStores, lastModified];

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    List<Credit> creditsConverted = [];
    if (data?['credits'] != null) {
      creditsConverted = data?['credits']!.map<Credit>((e) => Credit.fromJson(e)).toList();
    }

    List<FavoriteStore> favoriteStoresConverted = [];
    if (data?['favoriteStores'] != null) {
      favoriteStoresConverted = data?['favoriteStores']!.map<FavoriteStore>((e) => FavoriteStore.fromJson(e)).toList();
    }

    return User(
      id: data?['id'],
      username: data?['username'],
      storeId: data?['storeId'],
      credits:
        data?['credits'] is Iterable ? creditsConverted : null,
      favoriteStores: 
        data?['favoriteStores'] is Iterable ? favoriteStoresConverted : null,
      lastModified: data?['lastModified']
    );
  }

  Map<String, dynamic> toFirestore() {
    List<Map<String, Object?>> creditsConverted = [];
    if (credits != null) {
      creditsConverted = credits!.map((e) => e.toJson()).toList();
    }

    List<Map<String, Object?>> favoriteStoresConverted = [];
    if (favoriteStores != null) {
      favoriteStoresConverted = favoriteStores!.map((e) => e.toJson()).toList();
    }

    return {
      if (id != null) "id": id,
      if (username != null) "username": username,
      if (storeId != null) "storeId": storeId,
      if (credits != null) "credits": creditsConverted,
      if (favoriteStores != null) "favoriteStores": favoriteStoresConverted,
      if (lastModified != null) "lastModified": lastModified
    };
  }
}
