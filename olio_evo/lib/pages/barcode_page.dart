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
  bool isApiCallProcess = false;

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
                padding: EdgeInsets.fromLTRB(0, 10, 10, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.qr_code_scanner),
                          onPressed: () {},
                          color: Color(0xff212435),
                          iconSize: 30,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: () {},
                        color: Color(0xff212435),
                        iconSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.green, width: 4),
                  ),
                ),
                onPressed: () {
                  scanBarcodeNormal().then((value) => {
                        setState(() {
                          isApiCallProcess = true;
                        }),
                        apiService.getProductBySlug(_scanBarcode).then(
                              (value) => {
                                if (value != null)
                                  {
                                    setState(() {
                                      isApiCallProcess = false;
                                    isNotFound = false;

                                    }),
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
                                      isApiCallProcess = false;

                                      isNotFound = true;
                                    })
                                  }
                              },
                            )
                      });
                  // Inserire qui le azioni da eseguire quando il bottone viene cliccato
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.2,
                      left: 0,
                      right: 0,
                      child: Text(
                        "Tocca lo schermo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage("assets/images/barcode_scan.png"),
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 0.9,
                      fit: BoxFit.contain,
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
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700],
                          fontFamily: "Roboto",
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ),
              Visibility(
                child: Center(
                    child: isApiCallProcess
                        ?  Padding(
                            padding: EdgeInsets.only(top: 20),child: CircularProgressIndicator(),)
                        : Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Barcode non trovato",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            ))),
                visible: isApiCallProcess || isNotFound,
              )
            ],
          )),
    );
  }
}
