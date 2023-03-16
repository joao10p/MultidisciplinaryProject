import 'package:woocommerce_api/woocommerce_api.dart';

class LoginResponseModel{
  bool success;
  int statusCode;
  String code;
  String message;
  Data data;


LoginResponseModel({this.success,this.statusCode,this.code,this.
message, this.data});


LoginResponseModel.fromJson(Map<String, dynamic> json){
  success= json['sucess'];
  statusCode= json['statusCode'];
  code= json['code'];
  message= json['message'];
  data= json['data']!= null ? new Data.fromJson(json['data']) : null;
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
  int id;
  String email;
  String nicename;
  String firstName;
  String lastname;
  String displayName;


  Data(this.token, this.id, this.email, this.firstName,this.lastname, 
  this.displayName);

  Data.fromJson(Map<String,dynamic> json){
    token=json['token'];
    id= json['id'];
    email=  json['email'];
    nicename=json['nicename'];
    firstName=json['firstName'];
    displayName=json['dispalyName'];

  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data= new Map<String,dynamic>();

    data['token']=this.token;
    data['id']=this.id;
    data['email']=this.email;
    data['nicename']=this.nicename;
    data['firstname']=this.firstName;
    data['lastname']=this.lastname;
    data['dispalyName']=this.displayName;
    
    return data;
  }




Future<LoginResponseModel> loginCustomer(String username, String password) async{
  LoginResponseModel model;
  WooCommerceAPI api;

  try{

      Credentials credential= Credentials(username,password);
      api.postAsync("login", credential.toJson());

  
}catch(e){}
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