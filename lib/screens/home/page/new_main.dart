import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gide/core/constants/route_constants.dart';
import 'package:gide/core/models/announcement_model.dart';
import 'package:gide/core/models/item_model.dart';
import 'package:gide/core/models/store_model.dart';
import 'package:gide/core/services/store_service.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget{

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  String _searchText = "";
  final yourScrollController = ScrollController();

  List<Item> _items = [];
  List<Announcement> _announcements = [];

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      _getStuff();
    });
  }

  _getStuff() async {
    var snapshot = await FirebaseFirestore.instance.collection('stores').orderBy("lastModified").get();
    snapshot.docs.forEach((doc) {
      Store store = Store.fromFirestore(doc, null);
      int counter = 0;

      if (store.items!.isNotEmpty) {
        for (int i = store.items!.length - 1; i >= 0; i--) {
          if (counter < 3) {
            setState(() {
              _items = [..._items, store.items![i]];
            });
            
            counter++;
          }
        }
      }

      counter = 0;

      if (store.announcements!.isNotEmpty) {
        for (int i = store.announcements!.length - 1; i >= 0; i--) {
          if (counter < 3) {
            setState(() {
              _announcements = [..._announcements, store.announcements![i]];
            });
            
            counter++;
          }
        }
      }

      counter = 0;

    });
  }

  Widget build(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Material(
        color:const Color(0xFFF6F6F6),
        child: SafeArea(
          child: Center(
            child: Container(
              width: width * .844,
                child: SingleChildScrollView(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFavStoreItems(context),
                      _buildAnnouncements(context)
                    ],
                  ),
                ),
              
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * .1583,
      child: Center(
        child: TextField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(11),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(11),
            ),
            hintText: "Search here...",
            hintStyle: const TextStyle(color: Color(0xFFC2C2C2)),
            suffixIcon: const Icon(Icons.search, color: Color(0xFF3D3D3D)),
            filled: true,
            fillColor: Colors.white
          ),
          onChanged: (text) {
            _searchText = text;
          },
        ),
      ),
    );
  }

  Widget _buildFavStoreItems(BuildContext context){
    ScrollController sc = ScrollController(initialScrollOffset: 50);
   
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * .335,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                'Favorite Store Items',
                style: GoogleFonts.poppins(
                  fontSize: 19
                ),
              )
            ),
          ),
          SizedBox(height: height * .01),
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overScroll) {
                return false;
              },
              child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(Color(0xFF505050)),
                    trackVisibility: MaterialStateProperty.all(true),
                    trackColor: MaterialStateProperty.all(Color(0xFFE8E8E8)),
                    radius: Radius.circular(20),
                    thickness: MaterialStateProperty.all(height * .00875)
                  )
                ),
                child: Scrollbar(
                  isAlwaysShown: false,
                  controller: ScrollController(initialScrollOffset: 0),
                  child: _items.isNotEmpty ? Align(
                    alignment: Alignment.centerLeft,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return _buildPromotionTab(
                          context, 
                          'never lol', 
                          _items[index].name, 
                          _items[index].description, 
                          _items[index].imageLink,
                          _items[index].storeId
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(width: height * .01875),
                    ),
                  ) : Container(
                      margin: const EdgeInsets.only(top: 40),
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
                    ),
                ),
              ),
            )
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPromotionTab(BuildContext context, String discountEnd, String name, String type, String coverImageLink, String storeId){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () async {
        Store store = await StoreSerice.findStoreById(storeId);
        Navigator.of(context).pushNamed(storeRoute, arguments: store);
      },
      child: Center(
        child: Column(
          children: [
            Container(
              height: height * .25875,
              width: width * .312625,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Container(
                width: width * .325,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: height * .15475,
                          width: width * .325,
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: height * .15125,
                                  width: width * .27125,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Image.network(
                                      coverImageLink,
                                      fit: BoxFit.fill
                                    ),
                                  )    
                                ),
                              ),
                            ],
                        )
                        ),

                        Center(
                          child: Container(
                            width:  width * .27125,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14.5
                                    )
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    type,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Color(0xFF838383),
                                        fontSize: 11
                                    )
                                  ),
                                ),
                                SizedBox(height: height * .0175),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Check it out ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xFF4670C1),
                                              fontFamily: 'Poppins'
                                              )
                                          ),
                                          SvgPicture.asset(
                                            'assets/icons/Arrow 1.svg',
                                            height: height * .01,
                                            width: width * .01,
                                            color: Color(0xFF4670C1),
                                          )
                                              
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ) 
                    ],
                  ),
                )
                
              )
            ),
            SizedBox(height: height * .00)
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncements(BuildContext context){
    
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * .445,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: height * .02),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                'Announcements',
                style: GoogleFonts.poppins(
                  fontSize: 19
                ),
              )
            ),
          ),
          SizedBox(height: height * .013),
          Expanded(
            child: Center(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overScroll) {
                  return false;
                },
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: _announcements.length,
                  itemBuilder: (context, index) {
                    return _buildAnnouncementTab(
                      context, 
                      _announcements[index].storeName, 
                      _announcements[index].text, 
                      _announcements[index].coverImageLink,
                      _announcements[index].storeId
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: height * .03375),
                ) 
              )
            )
          )
        ],
      ),
    );
  }

  Widget _buildAnnouncementTab(BuildContext context, String name, String description, String coverImageLink, String storeId){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () async {
        Store store = await StoreSerice.findStoreById(storeId);
        Navigator.of(context).pushNamed(storeRoute, arguments: store);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(11)
        ),
        width: width * .844,
        height: height * .14125,
        child: Center(
          child: Container(
            height: height * .11625,
            width: width * .7856,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900
                          )
                        ),
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            description,
                            style: const TextStyle(
                              fontSize: 14
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            softWrap: false,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Color(0xFF4670C1),
                            fontSize: 12
                          )
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height* .11125,
                  width: height * .11125,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.network(
                      coverImageLink,
                      fit: BoxFit.fill
                    ),
                  )
                                    
                ),
                
              ],
            ),
          ),
        ),
      ),
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