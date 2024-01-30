import 'package:flutter/material.dart';
import 'package:gide/core/models/store_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultItem extends StatelessWidget {
  const ResultItem({ Key? key, required this.store }) : super(key: key);
  
  final Store store;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * .15,
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.network(
                store.coverImageLink,
                fit: BoxFit.cover
              ),
            ),
          ),
          Text(
            store.name, 
            style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w700)
          ),
          Flexible(
            child: Container(
              width: width,
              child: Text(
                store.description,
                overflow: TextOverflow.fade,
              ),
            ),
          )
        ]
      ),
    );
  }
}