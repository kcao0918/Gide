import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:gide/core/models/store_model.dart';
import 'package:gide/screens/home/page/favorites.dart';
import 'package:gide/screens/place_locator/bottom_bar.dart';
import 'package:gide/screens/place_locator/filter_item.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class PlaceLocator extends StatefulWidget {
  const PlaceLocator({Key? key}) : super(key: key);

  @override
  State<PlaceLocator> createState() => _PlaceLocatorState();
}

class _PlaceLocatorState extends State<PlaceLocator> {
  late GoogleMapController _controller;
  PageController _pageController = PageController();

  var lng, lat;

  bool isMapVisible = false;

  final geo = Geoflutterfire();
  final _firestore = FirebaseFirestore.instance;
  late StreamSubscription _subscription;

  List<Store> _stores = [];
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  int _selectedIndex = 0;

  @override
  initState() {
    super.initState();

    getLocation();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Widget _buildFilters() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: 40,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: const [
            FilterItem(name: "Interests"),
            FilterItem(name: "Surprise Me!"),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAppBar() {
    return Positioned(
      top: 15,
      right: 15,
      left: 15,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 252, 252, 252), borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(8),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                splashColor: Colors.grey,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // _buildTextField(),
              _buildFilters()
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller = controller;

    Future.delayed(
      const Duration(milliseconds: 550),
        () => setState(() {isMapVisible = true;}
      )
    );

    if (lat != null && lng != null) {
      double distance = 0.5;
      await getNearbyStores(LatLng(lat, lng), distance);

      _circles.add(Circle(
        strokeColor: Colors.transparent,
        fillColor: Color(0x3069D0FF),
        circleId: const CircleId("self-circle"),
        center: LatLng(lat, lng),
        radius: distance * 1000,
      ));
    } 
  }

  Future getLocation() async {
    final location = loc.Location();
    var currentLocation = await location.getLocation();

    setState(() {
      lat = currentLocation.latitude;
      lng = currentLocation.longitude;
    });
  }

  // distance in km
  Future<void> getNearbyStores(LatLng loc, double distance) async {
    GeoFirePoint center = geo.point(latitude: loc.latitude, longitude: loc.longitude);

    var collectionReference = _firestore.collection('stores');
    Stream<List<DocumentSnapshot>> stream = geo.collection(
      collectionRef: collectionReference
    )
    .within(
      center: center, 
      radius: distance, 
      field: 'location', 
      strictMode: true
    );

    _subscription = stream.listen((List<DocumentSnapshot> documentList) {
      documentList.forEach((doc) { 
        print(doc.data());
        Store store = Store.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>, null);
        _stores.add(store);
      });

      for (int i = 0; i < _stores.length; i++) {
        var store = _stores[i];

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(store.id), 
              position: LatLng(store.location.latitude, store.location.longitude),
              onTap: () {
                updateSelectedIndex(i);
              }
            )
          );
        });
      }
    });
  }

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;

      _pageController.animateToPage(
        index, 
        duration: const Duration(milliseconds: 500), 
        curve: Curves.ease
      );
    });
  }

  void updateCameraPosition(double lat, double lng) {
    _controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(lat, lng)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            (lat == null || lng == null) ? 
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[100],
              child: const Center(
                child: CircularProgressIndicator(),
              )
            ) : AnimatedOpacity(
              curve: Curves.fastOutSlowIn,
              opacity: isMapVisible ? 1.0 : 0,
              duration: const Duration(milliseconds: 600),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 16),
                markers: _markers,
                circles: _circles,
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false
              ),
            ),
            _buildAppBar(),
            _stores.length > 0 ? BottomBar(
              stores: _stores,
              selectedIndex: _selectedIndex,
              updateSelectedIndex: updateSelectedIndex,
              pageController: _pageController,
              updateCameraPosition: updateCameraPosition
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
