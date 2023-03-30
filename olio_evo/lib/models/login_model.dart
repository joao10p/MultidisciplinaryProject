
import 'package:dio/dio.dart';

import '../api_service.dart';

class LoginResponseModel{
  bool success;
  int statusCode;
  String code;
  String message;
  Data data;


LoginResponseModel({this.success,this.statusCode,this.code,this.
message, this.data});


LoginResponseModel.fromJson(Response response){
  success= response.statusCode == 200 ? true : false ;
  statusCode= response.statusCode;
  code= null;
  message="Autenticated";
  data= response.data!= null ? new Data.fromJson(response.data) : null;
}

Map <String, dynamic> toJson(){
  final Map<String, dynamic> data= new Map<String, dynamic>();
  data['success']= this.success;
  data['statusCode']= this.statusCode;
  data['code']= this.code;
  data['message']= this.message;
  if(this.data!=null){
    data['data']= this.data.toJson();
  }
  return data;
}


}
class Data{
  String token;
  
  String email;
  String nicename;
  String displayName;


  Data(this.token, this.email,
  this.displayName);

  Data.fromJson(Map<String,dynamic> json){
    token=json['token'];
    email=  json['user_email'];
    nicename=json['user_nicename'];
    displayName=json['user_display_name'];

  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data= new Map<String,dynamic>();

    data['token']=this.token;
    data['email']=this.email;
    data['nicename']=this.nicename;
    data['dispalyName']=this.displayName;
    
    return data;
  }



}

class Credentials{
  String username;
  String password;


Credentials(String username, String password){
  this.username=username;
  this.password=password;


  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data= new Map<String,dynamic>();

    data['username']=this.username;
    data['password']=this.password;
    
    return data;
  }


}