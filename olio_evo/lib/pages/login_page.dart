import 'package:flutter/material.dart';

import '../api_service.dart';
import '../models/login_model.dart';
import '../utils/ProgressHUD.dart';
import '../utils/former_helper.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Credentials credentials;
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String username;
  String password;
  API api;

  @override
  void initState() {
    api = API();
    super.initState();
  }

  @override
  Widget build(BuildContext) {
    return ProgressHUD(
        child: uiSetup(context), inAsyncCall: isApiCallProcess, opacity: 0.3);
  }

  @override
  Widget uiSetup(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            margin: EdgeInsets.all(0),
                            padding: EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              color: Color(0x1fffffff),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 25, horizontal: 0),
                                  child:

                                      ///***If you have exported images you must have to copy those images in assets/images directory.
                                      Image(
                                    image: AssetImage(
                                        "assets/images/olivevo_logo.jpg"),
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: Form(
                                    key: globalKey,
                                    child: Column(
                                      children: <Widget>[
                                        const SizedBox(height: 25),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                            keyboardType: TextInputType
                                                .emailAddress,
                                            onSaved: (input) => username =
                                                input,
                                            validator: (input) => !input
                                                    .contains('@')
                                                ? "Inserisci una mail valida"
                                                : null,
                                            decoration: InputDecoration(
                                                hintText: "Indirizzo email",
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255,
                                                      239,
                                                      239,
                                                      239), //Theme.of(context).accentColor.withOpacity(0.2)
                                                )),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .greenAccent)),
                                                prefixIcon: Icon(
                                                  Icons.email,
                                                  color: Colors.greenAccent,
                                                ))),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                          keyboardType: TextInputType.text,
                                          onSaved: (input) => password = input,
                                          validator: (input) => input.length < 3
                                              ? "La password eve essere più lunga di 3 caratteri"
                                              : null,
                                          obscureText: hidePassword,
                                          decoration: InputDecoration(
                                            hintText: "Password",
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.greenAccent)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 69, 203, 132))),
                                            prefixIcon: Icon(
                                              Icons.lock,
                                              color: Colors.greenAccent,
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  hidePassword = !hidePassword;
                                                });
                                              },
                                              color: Colors.greenAccent,
                                              icon: Icon(hidePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 10),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "Password dimenticata?",
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w100,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 12, 111, 42),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 15),
                                          child: MaterialButton(
                                            onPressed: () {
                                              if (validateAndSave()) {
                                                setState(() {
                                                  isApiCallProcess = true;
                                                });

                                                api
                                                    .loginCustomer(Credentials(
                                                        username, password))
                                                    .then((ret) {
                                                  setState(() {
                                                    isApiCallProcess = false;
                                                  });
                                                  if (ret.success) {
                                                    FormHelper.showMessage(
                                                      context,
                                                      "OlioEvo",
                                                      "Login effetuato con successo!",
                                                      "Ok",
                                                      () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HomePage()));
                                                      },
                                                    );
                                                  } else {
                                                    FormHelper.showMessage(
                                                      context,
                                                      "OlioEvo",
                                                      "Credenziali errate",
                                                      "Ok",
                                                      () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LoginPage()));
                                                      },
                                                    );
                                                  }
                                                });
                                              }
                                            },
                                            color: Color(0xffffffff),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 5, 79, 22),
                                                  width: 1),
                                            ),
                                            padding: EdgeInsets.all(16),
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                            textColor: Color.fromARGB(
                                                255, 36, 160, 65),
                                            height: 50,
                                            minWidth: 200,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Divider(
                                                color: Color(0xff808080),
                                                height: 1,
                                                thickness: 0,
                                                indent: 5,
                                                endIndent: 3,
                                              ),
                                            ),
                                            Text(
                                              "Oppure accedi con",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w100,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 10,
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Divider(
                                                color: Color(0xff808080),
                                                height: 16,
                                                thickness: 0,
                                                indent: 3,
                                                endIndent: 5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {},
                                                color: Color(0xff212435),
                                                iconSize: 30,
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {},
                                                color: Color(0xff212435),
                                                iconSize: 30,
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {},
                                                color: Color(0xff212435),
                                                iconSize: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 10, 5, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 5, 0),
                                                child: Text(
                                                  "Non hai ancora un account?",
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 10,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 0),
                                                child: MaterialButton(
                                                  onPressed: () {},
                                                  color: Color(0xffffffff),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    side: BorderSide(
                                                        color:
                                                            Color(0xff808080),
                                                        width: 1),
                                                  ),
                                                  padding: EdgeInsets.all(16),
                                                  child: Text(
                                                    "Registrati",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                  textColor: Color(0xff000000),
                                                  height: 35,
                                                  minWidth: 100,
                                                ),
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
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
