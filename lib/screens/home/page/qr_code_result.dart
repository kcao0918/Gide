import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gide/core/models/credit_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeResultPage extends StatefulWidget {
  final Credit credit;
  const QRCodeResultPage({ Key? key, required this.credit }) : super(key: key);

  @override
  State<QRCodeResultPage> createState() => _QRCodeResultPageState();
}

class _QRCodeResultPageState extends State<QRCodeResultPage> {
  String _getJson() {
    return jsonEncode({ 
      'id': widget.credit.id,
      'expireDate': widget.credit.expireDate.toDate().toString(),
      'storeId': widget.credit.storeId,
      'amtOff': widget.credit.amtOff,
      'coverImageLink': widget.credit.coverImageLink,
      'storeName': widget.credit.storeName
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QrImage(data: _getJson())
          ],
        ),
      ),
    );
  }
}