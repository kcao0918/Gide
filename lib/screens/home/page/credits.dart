import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gide/core/constants/route_constants.dart';
import 'package:gide/core/models/credit_model.dart';
import 'package:gide/core/models/store_model.dart';
import 'package:gide/core/models/user_model.dart';
import 'package:gide/core/services/auth_service.dart';
import 'package:gide/core/services/store_service.dart';
import 'package:gide/screens/home/page/favorites.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_line/dotted_line.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  State<CreditsPage> createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  var _userStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userStream = FirebaseFirestore.instance.collection("users").doc(AuthenticationService.userInfo!.id).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Material(
        color: const Color(0xFFF6F6F6),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              height: height,
              width: width * .85,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Credits',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
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

                        List<Credit> creditsReversed = user.credits!.reversed.toList();

                        return creditsReversed.isNotEmpty ? ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) { 
                              Credit credit = creditsReversed[index];
                              DateTime expiredDate = credit.expireDate.toDate();

                              return GetCredit(key: Key(credit.id), name: credit.storeName, percent: (credit.amtOff * 100).toInt(), date: "${expiredDate.month}/${expiredDate.day}/${expiredDate.year}", coverImageLink: credit.coverImageLink, credit: credit);
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                            itemCount: creditsReversed.length
                          ),
                        ) : Container(
                          margin: const EdgeInsets.only(top: 80),
                          child: Column(
                            children: [
                              SvgPicture.asset('assets/icons/empty-box.svg'),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "There is nothing here...", 
                                  style: GoogleFonts.poppins(
                                    fontSize: 15, color: Color(0xFFC0C0C0)
                                  )
                                )
                              )
                            ],
                          )
                        );
                      }
                    ) : Container()
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GetCredit extends StatefulWidget {
  final String name;
  final int percent;
  final String date;
  final String coverImageLink;
  final Credit credit;

  const GetCredit({ Key? key, required this.name, required this.percent, required this.date, required this.coverImageLink, required this.credit }) : super(key: key);

  @override
  State<GetCredit> createState() => _GetCreditState();
}

class _GetCreditState extends State<GetCredit> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(qrCodeResultRoute, arguments: widget.credit);
      },
      style: ElevatedButton.styleFrom(
        shadowColor: const Color(0x68AFAFAF),
        elevation: 2,
        primary: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFFFFFFF)
        ),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: width * .2,
                        width: width * .2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(widget.coverImageLink),
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.name, 
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.black, 
                          fontSize: 12
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
            const DottedLine(
              lineLength: 100,
              direction: Axis.vertical,
              dashLength: 3,
              dashColor: Colors.grey,
              dashGapLength: 3,
            ),
            SizedBox(
              width: 80,
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black
                      ),
                      children: [
                        TextSpan(text: '-${widget.percent}% ', style: const TextStyle(
                            color: Color(0xFF4670C1),
                            fontWeight: FontWeight.w700
                          )
                        ),
                        const TextSpan(text: "off", style: TextStyle(fontSize: 14))
                      ]
                    )
                  ),
                  Text(widget.date, style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF7E7E7E)))
                ],
              ),
            )
          ]
        )
      ),
    );
  }
}
