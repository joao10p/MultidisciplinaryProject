// @dart=2.9
import 'package:flutter/material.dart';
import 'package:olio_evo/config.dart';
import 'package:olio_evo/api_service.dart';
import 'package:olio_evo/models/customer.dart';
import 'package:olio_evo/utils/ProgressHUD.dart';
import 'package:olio_evo/utils/former_helper.dart';
import 'package:olio_evo/utils/validator_service.dart';

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
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          automaticallyImplyLeading: true,
          title: Text("Sign Up"),
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
        padding: EdgeInsets.all(10), // container to insert colors
        child: Align(
          alignment: Alignment.topLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FormHelper.fieldLabel("Firts Name"), //parsing the first name
            FormHelper.textInput(
              context, //passing the context
              model.firstName,
              (value) => {
                this.model.firstName = value,
              },
              onValidate: (value) {
                if (value.toString().isEmpty) {
                  return 'Please Enter First Name.';
                }
                return null;
              },
            ),

            FormHelper.fieldLabel("Last Name"), //parsing the first name
            FormHelper.textInput(
              context, //passing the context
              model.firstName,
              (value) => {
                this.model.lastName = value,
              },
              onValidate: (value) {
                if (value.toString().isEmpty) {
                  return 'Please Enter Last Name.';
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
                  return 'Please Email id correct.';
                }
                if (value.isNotEmpty && !value.toString().isValidEmail()) {
                  return 'Please enter valid e-mail';
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
                  return 'Please Enter the password.';
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
            SizedBox(
              height: 20,
            ),
            new Center(
              child: FormHelper.saveButton(
                "Register",
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
                            "Registartion Succesful",
                            "Ok",
                            () {
                              Navigator.of(context).pop();
                            },
                          );
                        } else {
                          FormHelper.showMessage(
                            context,
                            "OlioEvo",
                            "Email Already registered",
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
          ]),
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
