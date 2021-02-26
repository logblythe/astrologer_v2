import 'dart:async';
import 'dart:convert';

import 'package:astrologer/core/data_model/khalti_payment.dart';
import 'package:astrologer/core/service/home_service.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

enum PaymentStatus { pending, purchased, error }

class KhaltiHelper {
  /// [MethodChannel] invoke relation to native platform.
  /// Checkout for more info https://flutter.dev/docs/development/platform-integration/platform-channels?tab=ios-channel-objective-c-tab
  static const platformChannel = MethodChannel("cosmos-khalti");
  static const _khaltiSecretKey =
      "live_secret_key_7261878c6466400c9b9c45566ba2ffe4";

  StreamController<Map> _purchaseStream = StreamController.broadcast();
  KhaltiPayment _khaltiPayment;
  var result;

  get purchaseStream => _purchaseStream;

  Future<void> initPayment(HomeService homeService) async {
    // Unique Id for every payment invoke.
    var uuid = Uuid();
    var productId = uuid.v4();
    //Implying Khalti Payment details and configuration.
    _khaltiPayment = KhaltiPayment(
        publicKey: "live_public_key_e5547cd88d0e43019ae1392f082b28dc",
        productName: "Question to astrologer.",
        amount: homeService.priceAfterDiscount.toInt()*100*116,
        productId: productId);
    await _invokePlatformMethodChannel(_khaltiPayment.toMap());
  }

  Future<void> _invokePlatformMethodChannel(var arg) async {
    /// Response contain two parameter [isSuccess] [message]
    /// isSuccess return true when transaction is successfully and false when transaction is failed.
    /// on error its only contain  error message string but when success its contain response of transaction.
    try {
      result =
          await platformChannel.invokeMethod("initiate_khalti_gateway", arg);
    } on PlatformException catch (e) {
      print(e);
    }
    if (result["isSuccess"]) {
      _khaltiPaymentVerification(result);
    } else {
      _purchaseStream.sink.add({
        "status": PaymentStatus.error,
        "data": result["message"],
      });
    }
  }

  Future<void> _khaltiPaymentVerification(var data) async {
    var header = {
      "Authorization": "Key $_khaltiSecretKey",
      "Content-Type" : "application/json"
    };
    var payLoad = {
      "token": "${data["message"]["token"]}",
      "amount": data["message"]["amount"]
    };
    print(jsonEncode(payLoad));
    http.Response response = await http.post(
        "https://khalti.com/api/v2/payment/verify/",
        headers: header,
        body: jsonEncode(payLoad));
    print(response.statusCode);
    if (response.statusCode == 200) {
      _purchaseStream.sink.add({
        "status": PaymentStatus.purchased,
        "data": result["message"],
      });
    } else {
      _purchaseStream.sink.add({
        "status": PaymentStatus.error,
        "data": result["message"],
      });
    }
  }

  void dispose() {
    _purchaseStream.close();
  }
}
