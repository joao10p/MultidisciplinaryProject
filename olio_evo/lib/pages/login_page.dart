import 'package:flutter/material.dart';
import 'package:olio_evo/utils/ProgressHUD.dart';
import 'package:olio_evo/utils/former_helper.dart';


import '../api_service.dart';
import '../config.dart';
import '../models/login_model.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState()=> _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{
  Credentials credentials;
  bool hidePassword = true;
  bool isApiCallProcess= false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String username;
  String password;
  API api;

  @override
  void initState(){
      api= API();
      super.initState();
  }

  @override
  Widget build(BuildContext){
      return ProgressHUD(child: uiSetup(context), inAsyncCall: isApiCallProcess,
      opacity:0.3);
  }

Widget uiSetup(BuildContext context){
  
  return Scaffold(
    backgroundColor: Theme.of(context).accentColor,
    body:SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFEFEFEF),//Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                      offset: Offset(0,10),
                      blurRadius:20)
                  ],
                 ),
                 child: Form( 
                  key:globalKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height:25),
                      Text("Login",
                      style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved:(input)=>username=input,
                        validator: (input)=> !input.contains('@')
                        ?"Email Id should be valid"
                        : null,
                      decoration:  InputDecoration(
                          hintText: "Emai Address",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:const Color(0xFFEFEFEF),//Theme.of(context).accentColor.withOpacity(0.2)
                              )),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor)),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).accentColor,
                        )
                         ) 
                      ),
                      SizedBox(height:20),
                      TextFormField(
                        style:
                          TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.text, 
                        onSaved:(input)=>password=input,
                        validator: (input)=>input.length<3
                          ? "Password should be more than 3 chracters"
                          : null,
                        obscureText: hidePassword,
                        decoration: new InputDecoration(
                          hintText:"Password",
                          enabledBorder: UnderlineInputBorder(
                            borderSide:BorderSide(
                              color: Theme.of(context)
                              .accentColor
                              .withOpacity(0.2))),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color:Theme.of(context).accentColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed:(){
                              setState(() {
                                hidePassword=!hidePassword;
                              });
                              },
                              color: Theme.of(context)
                              .accentColor
                              .withOpacity(0.4),
                              icon: Icon(hidePassword
                              ? Icons.visibility_off
                              :Icons.visibility),
                          ),
                        ), 
                        ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () { 
                          if( validateAndSave()){
                              setState(() {
                                  isApiCallProcess=true;
                              });

                              api.loginCustomer(Credentials(username, password))
                              .then(
                                (ret){
                                  if(ret!=null){
                                    FormHelper.showMessage(context, "OlioEvo", "Login succesful", "Ok",(){},
                                    );
                                  }else{
                                     FormHelper.showMessage(context, "OlioEvo", "Invalid Login", "Ok",
                                     (){},
                                     );
                                  }
                                  });
                              
                          }
                        },
                       
                      ),
                    SizedBox(height: 15,),
                    ],
                    ),
                  ),
              )
          ],
          )
        ],
        ),
        ),
    );
}

bool validateAndSave(){
    final form = globalKey.currentState;
    if(form.validate()){
        form.save();
        return true;
      }
      return false;
    }
  
}



  //Style of the button
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      
    ),
  );
  