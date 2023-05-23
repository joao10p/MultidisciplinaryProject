import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:olio_evo/api_service.dart';
import 'package:olio_evo/models/product.dart';
import 'package:olio_evo/pages/product_details.dart';
import 'package:olio_evo/provider/filters_provider.dart';
import 'package:provider/provider.dart';

class BarcodePage extends StatefulWidget {
  const BarcodePage({Key key}) : super(key: key);

  @override
  _BarcodePageState createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  bool isNotFound = false;
  API apiService = new API();
  String _scanBarcode = 'Unknown';

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    return barcodeScanRes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0x00000000),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(47, 165, 51, 1),
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.qr_code),
                          onPressed: () {},
                          color: Color(0xff212435),
                          iconSize: 24,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(47, 165, 51, 1),
                          width: 2,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: () {},
                        color: Color(0xff212435),
                        iconSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0x1f000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                  ),
                ),
                onPressed: () {
                  scanBarcodeNormal().then((value) => {
                        apiService.getProductBySlug(_scanBarcode).then(
                              (value) => {
                                if (value != null)
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetails(product: value),
                                      ),
                                    )
                                  }
                                else
                                  {
                                    setState(() {
                                      isNotFound = true;
                                    })
                                  }
                              },
                            )
                      });
                  // Inserire qui le azioni da eseguire quando il bottone viene cliccato
                 
                
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.1,
                      left: 0,
                      right: 0,
                      child: Text(
                        "Clicca qua",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage("assets/images/camera_green.jpg"),
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 0.9,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.3,
                      left: 0,
                      right: 0,
                      child: Text(
                        "per avviare lo scanner",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                child: Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Barcode non trovato",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ))),
                visible: isNotFound,
              )
            ],
          )),
    );
  }
}
