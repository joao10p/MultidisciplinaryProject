import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models/cart_response_model.dart';
import '../provider/cart_provider.dart';

class PaypalServices {
  String clientId = Config.paypalClientID;
  String secret = Config.paypalSecretKey;
  String returnURL = 'return.snippetcoder.com';
  String cancelURL = 'cancel.snippetcoder.com';
  // Below Method is to generate the AccessToken from PayPal
  Future<String> getAccessToken() async {
    try {
      var authToken = base64.encode(
        utf8.encode(clientId + ":" + secret),
      );
      var response = await Dio().post(
        '${Config.paypalURL}/v1/oauth2/token?grant_type=client_credentials',
        options: new Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        final body = response.data;
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

// you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "EUR",
    "decimalDigits": 2,
    "symbolBefore TheNumber": true,
    "currency": "EUR"
  };

  Map<String, dynamic> getOrderParams(BuildContext context) {
    var cartModel = Provider.of<CartProvider>(context, listen: false);
    cartModel.fetchCartItems();
    List items = [];

    cartModel.cartItems.forEach((CartItem item) {
      items.add({
        "name": item.productName,
        "quantity": item.qty,
        "price": item.productSalePrice != ""
            ? item.productSalePrice
            : item.productRegularPrice,
        "currency": defaultCurrency["currency"]
      });
    });

// checkout invoice details
    String totalAmount = cartModel.totalAmount.toString();
    String subTotalAmount = cartModel.totalAmount.toString();
    String shippingCost = '0';
    int shippingDiscountCost = 0;
    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  Future<Map<String, String>> createPaypalPayment(
    transactions,
    accessToken,
  ) async {
    try {
      var response = await Dio().post(
        "${Config.paypalURL}/v1/payments/payment",
        data: convert.jsonEncode(transactions),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );
      final body = response.data;
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];
          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      print(e);
    }
  }

  // Below method is use to executing Payment Transaction
  Future<Map<String, String>> executePayment(
    url,
    payerId,
    accessToken,
  ) async {
    try {
      var response = await Dio().post(
        url,
        data: convert.jsonEncode({"payer_id": payerId}),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );
      final body = response.data;
      if (response.statusCode == 200) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];
          String executeUrl = "";
          String approvalUrl = "https://www.paypal.com/it/home";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
