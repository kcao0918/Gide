import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gide/core/constants/route_constants.dart';
import 'package:gide/core/models/credit_model.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({ Key? key }) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  
  Barcode? _barcode;
  QRViewController? _controller;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();

    if (Platform.isAndroid) {
      await _controller!.pauseCamera();
    }
    
    _controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _buildQrView(context),
            _buildResult()
          ]
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey, 
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
        borderLength: 20,
        borderWidth: 10,
        borderRadius: 10,
        borderColor: Theme.of(context).primaryColor
      ),
    );
  }

  Widget _buildResult() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white24
      ),
      child: Text(
        _barcode != null ? 'Result : ${_barcode!.code}' : 'Scan a code!',
        maxLines: 3,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });

    _controller!.scannedDataStream.listen((barcode) {
      _controller!.pauseCamera();

      setState(() {
        _barcode = barcode;
      });

      final obj = jsonDecode(_barcode!.code);

      Credit tempCredit = Credit(
        id: obj['id'], 
        expireDate: Timestamp.fromDate(DateTime.parse(obj['expireDate'])),
        storeId: obj['storeId'], 
        amtOff: obj['amtOff'], 
        coverImageLink: obj['coverImageLink'], 
        storeName: obj['storeName']
      );

      Navigator.of(context).pushNamed(qrCodeConfirmationRoute, arguments: tempCredit);
    });
  }
}