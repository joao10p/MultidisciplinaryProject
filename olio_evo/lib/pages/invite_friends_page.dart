///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';

class OffersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 40),
                child: Icon(
                  Icons.favorite,
                  color: Color.fromRGBO(237, 66, 66, 1),
                  size: 200,
                ),
              ),
              Text(
                "Invita fino a 5 amici con il tuo codice personale!",
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Per ogni amico che effettua un acquisto riceverai un buono sconto del 10% da utilizzare sul tuo prossimo ordine.",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xff696767),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                child: TextField(
                  controller: TextEditingController(),
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color(0xff696767), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color(0xff696767), width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Color(0xff696767), width: 1.5),
                    ),
                    hintText: "CodiceAmico01",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff696767),
                    ),
                    filled: true,
                    fillColor: Color(0x00ffffff),
                    isDense: false,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {},
                color: Colors.green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  "Applica",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                textColor: Color(0xffffffff),
              ),
              //text con un codice casuale e sotto un bottone con scritto condividi
              Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Text(
                  "Codice personale (condiviso 0/5 volte)",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  "ASD67BXX32",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Condividi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  textColor: Color(0xffffffff),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
