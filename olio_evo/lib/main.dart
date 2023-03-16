
import 'package:flutter/material.dart';
import 'package:olio_evo/pages/signup_page.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Olio Evo',
      
     home: SignupPage()
    );
  }
}



