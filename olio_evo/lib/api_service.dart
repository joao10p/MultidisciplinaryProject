import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:olio_evo/models/customer.dart' as customer;
import 'package:olio_evo/config.dart';

import 'dart:convert';
import 'dart:io' show Platform;

import 'dart:async';
import "dart:collection";
import 'dart:convert';
import 'dart:io';
import "dart:math";
import "dart:core";
import 'package:crypto/crypto.dart' as crypto;
import 'package:olio_evo/models/login_model.dart';
import 'package:olio_evo/models/order_details.dart';
import 'package:olio_evo/shared_service.dart';
import 'package:olio_evo/utils/query_string.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'models/cart_request_model.dart';
import 'models/cart_response_model.dart';
import 'models/category.dart';
import 'models/customer.dart';
import 'models/customer_detail_model.dart';
import 'models/order.dart';
import 'models/product.dart';

/// [url] is you're site's base URL, e.g. `https://www.yourdomain.com`
///
/// [consumerKey] is the consumer key provided by WooCommerce, e.g. `ck_1a2b3c4d5e6f7g8h9i`
///
/// [consumerSecret] is the consumer secret provided by WooCommerce, e.g. `cs_1a2b3c4d5e6f7g8h9i`
///
/// [isHttps] check if [url] is https based
class API {
  String url;
  String consumerKey;
  String consumerSecret;
  bool isHttps;

  API({
    this.url,
    this.consumerKey,
    this.consumerSecret,
  }) {
    this.url = Config.url;
    this.consumerKey = Config.key;
    this.consumerSecret = Config.secret;

    if (this.url.startsWith("https")) {
      this.isHttps = true;
    } else {
      this.isHttps = false;
    }
  }

  /// Generate a valid OAuth 1.0 URL
  ///
  /// if [isHttps] is true we just return the URL with
  /// [consumerKey] and [consumerSecret] as query parameters
  String _getOAuthURL(String requestMethod, String endpoint) {
    String consumerKey = this.consumerKey;
    String consumerSecret = this.consumerSecret;

    String token = "";
    String url = this.url + "/wp-json/wc/v2/" + endpoint;

    //If the request is a login, change the url to acces with token
    if (endpoint == "login") {
      url = this.url + "/wp-json/jwt-auth/v1/token";
    }

    bool containsQueryParams = url.contains("?");

    if (this.isHttps == true) {
      return url +
          (containsQueryParams == true
              ? "&consumer_key=" +
                  this.consumerKey +
                  "&consumer_secret=" +
                  this.consumerSecret
              : "?consumer_key=" +
                  this.consumerKey +
                  "&consumer_secret=" +
                  this.consumerSecret);
    }

    Random rand = Random();
    List<int> codeUnits = List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    /// Random string uniquely generated to identify each signed request
    String nonce = String.fromCharCodes(codeUnits);

    /// The timestamp allows the Service Provider to only keep nonce values for a limited time
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    String parameters = "oauth_consumer_key=" +
        consumerKey +
        "&oauth_nonce=" +
        nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
        timestamp.toString() +
        "&oauth_token=" +
        token +
        "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = QueryString.parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString +
          Uri.encodeQueryComponent(key) +
          "=" +
          treeMap[key] +
          "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    String method = requestMethod;
    String baseString = method +
        "&" +
        Uri.encodeQueryComponent(
            containsQueryParams == true ? url.split("?")[0] : url) +
        "&" +
        Uri.encodeQueryComponent(parameterString);

    String signingKey = consumerSecret + "&" + token;
    crypto.Hmac hmacSha1 =
        crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1

    /// The Signature is used by the server to verify the
    /// authenticity of the request and prevent unauthorized access.
    /// Here we use HMAC-SHA1 method.
    crypto.Digest signature = hmacSha1.convert(utf8.encode(baseString));

    String finalSignature = base64Encode(signature.bytes);

    String requestUrl = "";

    if (containsQueryParams == true) {
      requestUrl = url.split("?")[0] +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    } else {
      requestUrl = url +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    }

    return requestUrl;
  }

  /// Handle network errors if [response.statusCode] is not 200 (OK).
  ///
  /// WooCommerce supports and give informations about errors 400, 401, 404 and 500
  bool _handleError(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return true;
      case 201:
        return true;
      case 400:
      case 401:
      case 404:
      case 500:

        //WooCommerceError.fromJson(json.decode(response.body)).toString());
        return false;
      default:
        throw Exception(
            "An error occurred, status code: ${response.statusCode}");
    }
  }

  Future<dynamic> getAsync(String endPoint, String url) async {
    if (url == null) {
      url = this._getOAuthURL("GET", endPoint);
    }

    try {
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      _handleError(response);
    } on SocketException {
      throw Exception('No Internet connection.');
    }
  }

  var authToken = base64.encode(
    //create token to access
    utf8.encode(Config.key + ":" + Config.secret),
  );

  Future<dynamic> postAsync(String endPoint, Map data) async {
    String url = _getOAuthURL("POST", endPoint);

    http.Client client = http.Client();
    http.Request request = http.Request('POST', Uri.parse(url));
    //Switch to choose the right header depending on the request
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
    request.body = json.encode(data);
    var response = await client.send(request);
    final result = await http.Response.fromStream(response);
    bool isGood = _handleError(result);
  }

//sometise throw an exception beacuse it receives
  Future<List<Category>> getCategories(String parent) async {
    String url;
    url = _getOAuthURL("GET", Config.categoriesURL);
    url += "&per_page=20";
    url += "&parent=" + parent;
    //39 è l'id della categoria parent che tiene tutti i sapori
    try {
      List<dynamic> result = await getAsync(null, url);

      if (result != null) {
        List<Category> data = new List<Category>();
        data = (result as List)
            .map(
              (i) => Category.fromJson(i),
            )
            .toList();
        return data;
      }
    } catch (e) {
      TODO: //miss implementation of exception
      print(e);
    }
  }

   Future<List<Category>> getSapori() async {
    String url;
    url = _getOAuthURL("GET", Config.categoriesURL);
    url += "&per_page=20";
    url += "&parent=39"; //39 è l'id della categoria parent che tiene tutti i sapori
    try {
      List<dynamic> result = await getAsync(null, url);

      if (result != null) {
        List<Category> data = new List<Category>();
        data = (result as List)
            .map(
              (i) => Category.fromJson(i),
            )
            .toList();
        return data;
      }
    } catch (e) {
      TODO: //miss implementation of exception
      print(e);
    }
  }

  Future<List<Product>> getProducts({
    int pageNumber,
    int pageSize,
    String strSearch,
    String tagName,
    String categoryId,
    String sortBy,
    List<int> productsIDs,
    String sortOrder = "asc",
  }) async {
    try {
      String parameter = "";

      if (strSearch != null) {
        parameter += "&search=$strSearch";
      }

      if (pageSize != null) {
        parameter += "&per_page=$pageSize";
      }

      if (pageNumber != null) {
        parameter += "&page=$pageNumber";
      }

      if (tagName != null) {
        parameter += "&tag=$tagName";
      }

      if (categoryId != null) {
        parameter += "&category=$categoryId";
      }

      if (sortBy != null) {
        parameter += "&orderby=$sortBy";
      }

      if (productsIDs != null) {
        parameter += "&include=${productsIDs.join(",").toString()}";
      }

      if (sortOrder != null) {
        parameter += "&order=$sortOrder";
      }

      String url = _getOAuthURL("GET", Config.productURL);
      url += parameter;
      List<Product> data = new List<Product>();
      List<dynamic> result = await getAsync(Config.productURL, url);
      if (result != null) {
        data = (result)
            .map(
              (i) => Product.fromJson(i),
            )
            .toList();
        return data;
      }
    } catch (e) {}
  }

  Future<LoginResponseModel> loginCustomer(Credentials credentials) async {
    LoginResponseModel model;
    String url = _getOAuthURL("POST", "login");
    try {
      var response = await Dio().post(url,
          data: {
            "username": credentials.username,
            "password": credentials.password
          },
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = <String, dynamic>{};
        json['success'] = true;
        json['statusCode'] = 200;
        json['code'] = '';
        json['message'] = '';
        json['data'] = response.data;
        model = LoginResponseModel.fromJson(json);
      }

      return model;
    } on DioError catch (e) {
      Map<String, dynamic> json = <String, dynamic>{};
      json['success'] = false;
      json['statusCode'] = e.response.statusCode;
      json['code'] = '';
      json['message'] = '';
      json['data'] = '';
      model = LoginResponseModel.fromJson(json);
      return model;
    }
  }

  Future<CartResponseModel> addToCart(CartRequestModel model) async {
    model.userId = int.parse(Config.userID);

    /*
    LoginResponseModel loginResponseModel = await SharedService.loginDetails();

    if (loginResponseModel.data != null) {
      model.userId = loginResponseModel.data.id;
    }
    */

    CartResponseModel responseModel;

    try {
      var response = await Dio().post(
        Config.url + Config.addToCartURL,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      print(Config.url + Config.addToCartURL);

      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
        
      }
      return responseModel;
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
      }
    }

    return responseModel;
  }

  Future<CartResponseModel> getCartItems() async {
    CartResponseModel responseModel;

    try {
      String url =
          "${Config.url}${Config.cartURL}?user_id=${Config.userID}&consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      print(url);

      var response = await Dio().get(
        url,
        options: Options(
          headers: {HttpHeaders.contentTypeHeader: "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return responseModel;
  }

  Future<bool> createCustomer(CustomerModel model) async {
    bool ret = false;
    String url = _getOAuthURL("POST", "customers");
    try {
      var response = await Dio().post(url,
          data: model.toJson(),
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          }));
      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }

  Future<String> getIdCustomer(Credentials credentials) async {
    String url = _getOAuthURL("GET", "customers");
    Map<String, String> data = {
      'username': credentials.username,
      'password': credentials.password,
    };
    try {
      var response = await Dio().post(url,
          data: data,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          }));
      if (response.statusCode == 200) {
        dynamic customerData = jsonDecode(response.data);
        // Ottiene l'ID del primo cliente dalla risposta
        return customerData[0]['id'].toString();
      }
    } on DioError catch (e) {}
  }

  Future<Product> getProductBySlug(String slug) async {
    // var info= await getAsync(Config.categoriesURL);
    try {
      List<dynamic> result =
          await getAsync(Config.productURL + "?&sku=" + slug, null);
      if (result.length >0) {
        return Product.fromJson(result[0]);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<CustomerDetailsModel> customerDetails() async {
    CustomerDetailsModel responseModel;

    try {
      String url =
          "${Config.url}/wp-json/wc/v2/${Config.customerUrl}/${Config.userID}?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        responseModel = CustomerDetailsModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }

    return responseModel;
  }

  Future<bool> createOrder(OrderModel model) async {
    model.customerId = 23;

    bool isOrderCreated = false;
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );

    try {
      var response = await Dio().post(Config.url + Config.orderURL,
          data: model.toJson(),
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (response.statusCode == 201) {
        isOrderCreated = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }

    return isOrderCreated;
  }

  Future<List<OrderModel>> getOrders() async {
    List<OrderModel> data = <OrderModel>[];

    try {
      String url =
          "${Config.url}${Config.orderURL}?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      print(url);

      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (i) => OrderModel.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<OrderDetailModel> getOrderDetails(int orderId) async {
    OrderDetailModel responseModel = OrderDetailModel();

    try {
      String url =
          "${Config.url}${Config.orderURL}/$orderId?consumer_key=${Config.key}&consumer_secret=${Config.secret}";

      print(url);

      var response = await Dio().get(url,
          options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ));

      if (response.statusCode == 200) {
        responseModel = OrderDetailModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return responseModel;
  }
}
