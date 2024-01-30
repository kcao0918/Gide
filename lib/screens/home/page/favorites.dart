
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gide/core/constants/route_constants.dart';
import 'package:gide/core/models/favorite_store_model.dart';
import 'package:gide/core/models/store_model.dart';
import 'package:gide/core/models/user_model.dart';
import 'package:gide/core/services/auth_service.dart';
import 'package:gide/core/services/store_service.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesPage extends StatefulWidget{
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  var _userStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userStream = FirebaseFirestore.instance.collection("users").doc(AuthenticationService.userInfo!.id).snapshots();
  }

  @override
  Widget build(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Material(
        color:const Color(0xFFF6F6F6),
        child: Center(
          child: SizedBox(
            height: height,
            width: width * 0.85,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  favorites(height, width)
                ],
              ),
            ),
          ),
        )
           
      )
    );
  }

  Widget favoriteText(double height, double width){
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Favorites',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w800
            )
          ),
      ),
    );
  }

  Widget favoriteTab(String name, String desc, String imageLink, FavoriteStore store, double height, double width){
    return 
      ElevatedButton(
        onPressed: () async {
          Store s = await StoreSerice.findStoreById(store.storeId);
          Navigator.of(context).pushNamed(storeRoute, arguments: s);
        },
        style: ElevatedButton.styleFrom(
          shadowColor: const Color(0x68AFAFAF),
          elevation: 2,
          primary: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11)
          )
        ),
        child: Container(
          height: height * .14125,
          width: width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: const Color(0xFFFFFFFF)
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: height * .11,
                  width: height * 0.11,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    image: DecorationImage(
                      image: NetworkImage(imageLink),
                      fit: BoxFit.cover
                    )
                  ),
                ),
                Flexible(
                  child: SizedBox(
                      height: height * .9,
                      width: width * .45,
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Colors.black
                                )
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                desc,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF838383),
                                  fontSize: 12
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                softWrap: false,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Learn More ',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF4670C1),
                                      fontFamily: 'Poppins'
                                      )
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/Arrow 1.svg',
                                    height: height * .01,
                                    width: width * .01
                                  )
                                ],
                              ),
                            )
                                      
                          ],
                        ),
                      )
                    ),
                  ),
                
                
              ],
            ),
          )
        )
      );
  }

  Widget favoriteList(double height, double width){
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: Center(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            return false;
          },
          child: AuthenticationService.userInfo != null ? StreamBuilder<Object>(
            stream: _userStream,
            builder: (context, snapshot) {

              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              
              User user = User.fromFirestore(snapshot.data as DocumentSnapshot<Map<String, dynamic>>, null);

              List<FavoriteStore> favoriteStoresReversed = user.favoriteStores!.reversed.toList();

              return favoriteStoresReversed.isNotEmpty ? ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.separated(
                  itemCount: favoriteStoresReversed.length,
                  itemBuilder: (context, index) {
                    FavoriteStore store = favoriteStoresReversed[index];
                    
                    return favoriteTab(
                      store.name, 
                      store.description,
                      store.coverImageLink,
                      store,
                      height, 
                      width
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: height * .01875),
                ),
              ) : Container(
                margin: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    SvgPicture.asset('assets/icons/empty-box.svg'),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "There is nothing here...", 
                        style: GoogleFonts.poppins(
                          fontSize: 15, color: const Color(0xFFC0C0C0)
                        )
                      )
                    )
                  ],
                )
              );
            }
          ) : Container()
        )
      )
    );
  }

  Widget favorites(double height, double width){
    return SizedBox(
      height: height * .875,
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            favoriteText(height, width),
            Expanded(
              child: favoriteList(height, width)
            )
          ],
        ),
      )
    );
  } 
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

