import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:gide/core/models/announcement_model.dart';
import 'package:gide/core/models/item_model.dart';

class Store extends Equatable {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final String coverImageLink;
  final GeoFirePoint location;
  final List<Announcement>? announcements;
  final List<Item>? items;
  final Timestamp lastModified;

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.coverImageLink,
    required this.location,
    required this.announcements,
    required this.items,
    required this.lastModified
  });

  @override
  List<Object?> get props => [id, name, location];

  factory Store.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final geo = Geoflutterfire();

    List<Announcement> announcementConverted = [];
    if (data?['announcements'] != null) {
      announcementConverted = data?['announcements']!.map<Announcement>((e) => Announcement.fromJson(e)).toList();
    }

    List<Item> itemsConverted = [];
    if (data?['items'] != null) {
      itemsConverted = data?['items']!.map<Item>((e) => Item.fromJson(e)).toList();
    }

    return Store(
      id: data?['id'],
      name: data?['name'],
      description: data?['description'],
      location: geo.point(
        latitude: data?['location']['geopoint'].latitude, 
        longitude: data?['location']['geopoint'].longitude
      ),
      ownerId: data?['ownerId'],
      coverImageLink: data?['coverImageLink'],
      announcements: data?['announcements'] is Iterable ? announcementConverted : null,
      items: data?['items'] is Iterable ? itemsConverted : null,
      lastModified: data?['lastModified']
    );
  }

  Map<String, dynamic> toFirestore() {
    List<Map<String, Object?>> announcementConverted = [];
    if (announcements != null) {
      announcementConverted = announcements!.map((e) => e.toJson()).toList();
    }

    List<Map<String, Object?>> itemsConverted = [];
    if (items != null) {
      itemsConverted = items!.map((e) => e.toJson()).toList();
    }

    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (location != null) "location": location.data,
      if (ownerId != null) "ownerId": ownerId,
      if (coverImageLink != null) "coverImageLink": coverImageLink,
      if (announcements != null) "announcements": announcementConverted,
      if (items != null) "items": itemsConverted,
      if (lastModified != null) "lastModified": lastModified
    };
  }
}