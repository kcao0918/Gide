import 'package:flutter/material.dart';
import 'package:gide/core/constants/route_constants.dart';
import 'package:gide/core/models/credit_model.dart';
import 'package:animated_check/animated_check.dart';
import 'package:animated_cross/animated_cross.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditConfirm extends StatefulWidget {
  final Credit credit;

  const CreditConfirm({ Key? key, required this.credit }) : super(key: key);

  @override
  State<CreditConfirm> createState() => _CreditConfirmState();
}

class _CreditConfirmState extends State<CreditConfirm> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _animationController =
      AnimationController(
        vsync: this, 
        duration: const Duration(seconds: 1)
      );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCirc
      )
    );
    
    _animationController.forward();
  }

  bool isValid() {
    return widget.credit.expireDate.toDate().isAfter(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isValid() ? AnimatedCheck(
                progress: _animation,
                size: 200,
                color: Colors.green[300],
              ) : AnimatedCross(
                progress: _animation,
                size: 200,
                color: Colors.red,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  isValid() ? "Credit at ${widget.credit.storeName} is still valid!" : 
                  "Credit at ${widget.credit.storeName} is invalid!",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: isValid() ? Colors.green[300] : Colors.red,
                    fontSize: 17
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  isValid() ? "Valid till ${widget.credit.expireDate.toDate().month}/${widget.credit.expireDate.toDate().day}/${widget.credit.expireDate.toDate().year}" : "Expired on ${widget.credit.expireDate.toDate().month}/${widget.credit.expireDate.toDate().day}/${widget.credit.expireDate.toDate().year}",
                  style: GoogleFonts.poppins(
                    color: isValid() ? Colors.green[300] : Colors.red,
                    fontSize: 20
                  ),
                ),
              ),
              isValid() ? Text(
                "${(widget.credit.amtOff * 100).toInt()}% off",
                style: GoogleFonts.poppins(
                  color: isValid() ? Colors.green[300] : Colors.red,
                  fontSize: 24
                ),
              ) : Container(),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(homeViewRoute, (route) => false);
                  }, 
                  child: const Text("Back")
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}