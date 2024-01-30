
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:gide/core/constants/route_constants.dart';
import 'package:gide/core/models/announcement_model.dart';
import 'package:gide/core/models/credit_model.dart';
import 'package:gide/core/models/item_model.dart';
import 'package:gide/core/models/store_model.dart';
import 'package:gide/core/services/auth_service.dart';
import 'package:gide/core/services/store_service.dart';
import 'package:gide/screens/auth/bloc/auth_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({Key? key}) : super(key: key);

  Widget build(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    var user = AuthenticationService.getCurrentUser()!;

    final geo = Geoflutterfire();

    if (AuthenticationService.userInfo != null) {
      context.read<AuthBloc>().add(LoadAuth());
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Material(
        color:const Color(0xFFF6F6F6),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: width * 0.8,
              child: Column(
                children: [
                  iconHeader(
                    height, 
                    width, 
                    'Account', 
                    'Edit and manage your account details', 
                    'assets/icons/profile/settings.svg'
                  ),
                  profileBox(
                    height, 
                    width, 
                    'hi', 
                    'hi', 
                    '123-1231-1231', 
                    user.email!,
                    context
                  ),
                  iconHeader(
                    height, 
                    width, 
                    'About Us', 
                    'Learn more about Gide', 
                    'assets/icons/profile/info.svg'
                  ),
                  infoBox(
                    height, 
                    width,
                    [boxEntry(
                      "Acknowledgements", 
                      'assets/icons/profile/heart.svg', 
                      () {},
                      width, height)
                    ]
                  ),
                  iconHeader(
                    height, 
                    width, 
                    'Store', 
                    'Manage Store', 
                    'assets/icons/profile/store.svg'
                  ),
                  infoBox(
                    height, 
                    width,
                    [
                      (
                        (AuthenticationService.userInfo != null && AuthenticationService.userInfo!.storeId != null) ? boxEntry(
                          "View store", 
                          'assets/icons/profile/heart.svg', 
                          () async {
                            if (AuthenticationService.userInfo == null) return;
                            if (AuthenticationService.userInfo!.storeId == null) {
                              showDialog(context: context, builder: (_) => AlertDialog(
                                title: const Text("Whoops!"),
                                content: const Text("Missing store. Create one first."),
                                actions: [
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop(false);
                                  }, child: Text("Ok"))
                                ],
                              ));
                  
                              return;
                            };
                            Store foundStore = await StoreSerice.findStoreById(AuthenticationService.userInfo!.storeId!);
                            /*
                            Store(
                                id: "f5321464-2cf6-4a47-83bf-18454bb0501e", 
                                name: "adsadasda", 
                                description: "sadasda", ownerId: "TFyLewRzBJSOvcPQFlTUH2EoYC02", 
                                location: geo.point(latitude: 40.756367000987495, longitude: -73.82177485819064), announcements: [
                                  Announcement(text: "something", timestamp: Timestamp.now(), storeId: "sdasdasda")
                                ],
                                items: [
                                  Item(name: "something", description: "nice description", imageLink: "https://www.elmundoeats.com/wp-content/uploads/2021/02/FP-Quick-30-minutes-chicken-ramen.jpg")
                                ]
                              )
                            */
                            Navigator.of(context).pushNamed(
                              storeRoute, 
                              arguments: foundStore
                            );
                          },
                          width, 
                          height
                        ) : boxEntry(
                          "Create store", 
                          'assets/icons/profile/plus.svg', 
                          () {
                            Navigator.of(context).pushNamed(createStoreRoute);
                          },
                          width, 
                          height
                        )
                      ),
                    ]
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget iconHeader(double height, double width, String headingOne, String headingTwo, String iconPath){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            height: width * .09,
            width: width * .09,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: const Color(0xFF4670C1),
            ),
            child: SvgPicture.asset(iconPath, fit: BoxFit.scaleDown),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  headingOne,
                  style: GoogleFonts.poppins(),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  headingTwo,
                  style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF838383)),
                ),
              )
            ],
          )
        ],
      )
    );
  }

  Widget profileBox(double height, double width, String user, String name, String phoneNumber, String email, BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(11)
      ),
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Container(
                height: height * .07125,
                width: height * .07125,
                margin: const EdgeInsets.only(right: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.asset(
                    'assets/images/noodles.png',
                    fit: BoxFit.fill
                  ),
                ) 
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AuthenticationService.userInfo != null ? AuthenticationService.userInfo!.username : "missing_name", style: GoogleFonts.poppins(fontSize: 16)),
                  Text(
                    '@' + (AuthenticationService.userInfo != null ? AuthenticationService.userInfo!.username : "missing_name"), 
                    style: GoogleFonts.poppins(
                      fontSize: 11, 
                      color: const Color(0xFF838383)
                    )
                  )
                ],
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(qrCodeScannerRoute);
              // Credit credit = Credit(
              //   id: "ok", 
              //   expireDate: Timestamp.now(), 
              //   storeId: "swqeqw", 
              //   amtOff: 0.1, coverImageLink: "", storeName: "time"
              // );

              // Navigator.of(context).pushNamed(qrCodeConfirmationRoute, arguments: credit);
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(Color(0x1FE0E0E0)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all<double>(0),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SvgPicture.asset('assets/icons/profile/qrcode.svg'),
                  ),
                  Text('Scan QR Code', style: GoogleFonts.poppins(color: Colors.black))
                ],
              )
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          profileEntry("Email", email),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutUser());
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(Color(0x1FE0E0E0)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all<double>(0),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.black, size: 15,),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Logout",
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.black)
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
          /*
          const Divider(
            height: 1,
            thickness: 1,
          ),
          profileEntry("Phone Number", "123-123-1234")
          */
        ],
      )
    );
  }

  Widget infoBox(double height, double width, List<Widget> items){
    return Container(
      width: width * .844,
      height: height * 0.07,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
      )
    );
  }

  Widget profileEntry(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF838383))
            ),
            Text(
              info,
              style: GoogleFonts.poppins(fontSize: 13)
            )
          ],
        ),
      ),
    );
  }

  Widget boxEntry(String title, String imagePath, Function onPress, double deviceWidth, double deviceHeight) {
    return ElevatedButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Color(0x1FE0E0E0)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        elevation: MaterialStateProperty.all<double>(0),
      ),
      onPressed: () {
        onPress();
      },
      child: Container(
        width: deviceWidth * .75,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Padding(
                child: SvgPicture.asset(imagePath),
                padding: const EdgeInsets.only(right: 4)
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}