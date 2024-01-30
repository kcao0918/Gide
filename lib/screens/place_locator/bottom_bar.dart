import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:gide/core/constants/route_constants.dart';
import 'package:gide/core/models/credit_model.dart';
import 'package:gide/core/models/store_model.dart';
import 'package:gide/core/models/user_model.dart';
import 'package:gide/core/services/auth_service.dart';
import 'package:gide/core/services/user_service.dart';
import 'package:gide/screens/place_locator/indicator.dart';
import 'package:gide/screens/place_locator/result_item.dart';
import 'package:uuid/uuid.dart';

class BottomBar extends StatefulWidget {
  final List<Store> stores;
  final int selectedIndex;
  final Function(int) updateSelectedIndex;
  final PageController pageController;
  final Function(double, double) updateCameraPosition;

  const BottomBar({ 
    Key? key, 
    required this.stores, 
    required this.selectedIndex,
    required this.updateSelectedIndex,
    required this.pageController,
    required this.updateCameraPosition
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final geo = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      bottom: 15,
      right: 15,
      left: 15,
      child: GestureDetector(
        onVerticalDragEnd: (dragUpdateDetails) { // TODO: Change the page here

          if (widget.stores.length == 0) {
            return;
          }

          double randomdouble = Random().nextDouble();

          randomdouble = double.parse(randomdouble.toStringAsFixed(2));

          Store store = widget.stores[widget.selectedIndex];

          Credit credit = Credit(
            id: const Uuid().v4(), 
            expireDate: Timestamp.fromDate(DateTime(2022, 6, 2)), 
            storeId: store.id, 
            coverImageLink: store.coverImageLink,
            amtOff: randomdouble,
            storeName: store.name
          );

          if (AuthenticationService.userInfo == null) return;

          AuthenticationService.userInfo!.credits;
          List<Credit> credits = AuthenticationService.userInfo != null ? [...AuthenticationService.userInfo!.credits!] : [];

          credits.add(credit);
          AuthenticationService.userInfo!.credits!.add(credit);

          User tempUser = User(
            id: AuthenticationService.userInfo!.id, 
            username: AuthenticationService.userInfo!.username, 
            credits: credits, 
            storeId: AuthenticationService.userInfo!.storeId,
            favoriteStores: AuthenticationService.userInfo!.favoriteStores,
            lastModified: Timestamp.now()
          );

          UserService.updateUser(tempUser);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Added credit of -${(credit.amtOff * 100).toInt()}% for ${store.name}."
              )
            )
          );
          
          Navigator.of(context).pushNamed(storeRoute, arguments: widget.stores[widget.selectedIndex]);

        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFCFCFC), 
            borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                width: 28.0,
                height: 6.0,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.0)
                ),
              ),
              SizedBox(
                width: width,
                height: height * 0.28,
                child: PageView.builder(
                  controller: widget.pageController,
                  onPageChanged: ((index) {
                    setState(() {
                      widget.updateSelectedIndex(index);
                    });

                    widget.updateCameraPosition(widget.stores[index].location.latitude, widget.stores[index].location.longitude);
                  }),
                  itemCount: widget.stores.length,
                  itemBuilder: (context, index) {
                    return ResultItem(store: widget.stores[index]);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(widget.stores.length, (index) => Indicator(isActive: widget.selectedIndex == index ? true : false))
                  ],
                ),
              )
            ],
          )
        ),
      )
    );
  }
}
