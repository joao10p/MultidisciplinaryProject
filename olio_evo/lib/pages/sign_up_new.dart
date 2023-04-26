///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';
import 'package:olio_evo/utils/validator_service.dart';

import '../api_service.dart';
import '../models/customer.dart';
import '../utils/ProgressHUD.dart';
import '../utils/former_helper.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  CustomerModel model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePAssword = true;
  bool isApiCallProcess = false;
  API api = API();

  @override
  void initState() {
    model = new CustomerModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          automaticallyImplyLeading: true,
          title: Text("Registrati"),
          centerTitle: true,
        ),
        body: ProgressHUD(
            child: Form(
              key: globalKey,
              child: _formUI(),
            ),
            inAsyncCall: isApiCallProcess,
            opacity: 0.3));
  }
      

  Widget _formUI() {
    return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child:
                      ///***If you have exported images you must have to copy those images in assets/images directory.
                      Image(
                    image: AssetImage("assets/images/olivevo_logo.jpg"),
                    height: 100,
                    width: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FormHelper.fieldLabel("Nome"), //parsing the first name
            FormHelper.textInput(
              context, //passing the context
              model.firstName,
              (value) => {
                this.model.firstName = value,
              },
              onValidate: (value) {
                if (value.toString().isEmpty) {
                  return 'Per favore inserisci il tuo nome.';
                }
                return null;
              },
            ),
              ]),
                ),
           
            FormHelper.fieldLabel("Cognome"), //parsing the first name
            FormHelper.textInput(
              context, //passing the context
              model.firstName,
              (value) => {
                this.model.lastName = value,
              },
              onValidate: (value) {
                if (value.toString().isEmpty) {
                  return 'Per favore inserisci il tuo cognome.';
                }
                return null;
              },
            ),
              FormHelper.fieldLabel("Email"), //parsing the first name
            FormHelper.textInput(
              context, //passing the context
              model.firstName,
              (value) => {
                this.model.email = value,
              },
              onValidate: (value) {
                if (value.toString().isEmpty) {
                  return 'Per favore inserisci una mail';
                }
                if (value.isNotEmpty && !value.toString().isValidEmail()) {
                  return 'Per favore inserisci una mail corretta';
                }
                return null;
              },
            ),
                FormHelper.fieldLabel("Password"), //parsing the first name
            FormHelper.textInput(
              context, //passing the context
              model.firstName,
              (value) => {
                this.model.password = value,
              },
              onValidate: (value) {
                if (value.toString().isEmpty) {
                  return 'Per favore metti la password.';
                }
                return null;
              },
              obscureText: hidePAssword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePAssword = !hidePAssword;
                  });
                },
                color: Theme.of(context).accentColor.withOpacity(0.4),
                icon: Icon(
                  hidePAssword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
                FormHelper.fieldLabel("Conferma password"), //parsing the first name
            FormHelper.textInput(
              context, //passing the context
              model.firstName,
              (value) => {
               
              },
              onValidate: (value) {
                if (value.toString()!=this.model.password) {
                  return 'Per favore metti la stessa password';
                }
                return null;
              },
              obscureText: hidePAssword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePAssword = !hidePAssword;
                  });
                },
                color: Theme.of(context).accentColor.withOpacity(0.4),
                icon: Icon(
                  hidePAssword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                     new Center(
              child: FormHelper.saveButton(
                "Registrati",
                () {
                  if (validateAndSave()) {
                    setState(() {
                      isApiCallProcess = true;
                    });
                    //Here there is the call to the API and then we fetch the result
                    api.createCustomer(model).then(
                      (ret) {
                        setState(() {
                          isApiCallProcess = false;
                        });
                        if (ret) {
                          FormHelper.showMessage(
                            context,
                            "OlioEvo",
                            "Registrazione avvenuta con successo",
                            "Ok",
                            () {
                              Navigator.of(context).pop();
                            },
                          );
                        } else {
                          FormHelper.showMessage(
                            context,
                            "OlioEvo",
                            "Esiste già un account con questa mail",
                            "Ok",
                            () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          "Hai gia un account?",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color.fromARGB(255, 13, 14, 13),
                          ),
                        ),
                      ),
                      SizedBox(width: 30,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: MaterialButton(
                          onPressed: () {},
                          color: Color.fromARGB(255, 56, 156, 6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side:
                                BorderSide(color: Color(0xff808080), width: 1),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          textColor: Color(0xffffffff),
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
        ),
      );
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
