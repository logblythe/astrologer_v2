import 'dart:async';

import 'package:astrologer/core/data_model/esewa_payment.dart';
import 'package:astrologer/core/service/home_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'khalti_helper.dart';

class ESewaHelper {
  /// [MethodChannel] invoke relation to native platform.
  /// Checkout for more info https://flutter.dev/docs/development/platform-integration/platform-channels?tab=ios-channel-objective-c-tab
  static const platformChannel = const MethodChannel("cosmos-eSewa");

  /// ESewa [Environments] are keys to switch between test and live server
  static const test = "ENVIRONMENT_TEST";
  static const live = "ENVIRONMENT_LIVE";
  static const testClientId =
      "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R";
  static const testSecretKey = "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==";

  //For Production
  static const liveClientId =
      "JAAMFg9TJgoLBB9FMgUGCAQNDBwLVzEBBAgWERoKGVs9O0g8Nl4kJCgyJSg=";
  static const liveSecretKey = "BhwIWQAAAgQXCBwXFg1dDhUYHA==";

  StreamController<Map> _purchaseStream = StreamController.broadcast();

  get purchaseStream => _purchaseStream;

  Future<void> initPayment(HomeService homeService) async {
    // Unique Id for every payment invoke.
    var uuid = Uuid();
    var productId = uuid.v4();

    print(homeService.priceAfterDiscount);
    ESewaPayment payment = ESewaPayment(
        // Actual cost must be implement here.
        productPrice: homeService.priceAfterDiscount*116,
        productName: "Question to astrologer.",
        productId: productId,
        callBackUrl: "");
    print(payment.toMap(payment));

    var _paymentDetails = ESewaPayment().toMap(payment);
    var _eSewaConfig = {
      "clientId": "$liveClientId",
      "secretKey": "$liveSecretKey",
      "environment": "$live"
    };

    var platformArg = [_eSewaConfig, _paymentDetails];
    await _invokePlatformMethodChannel(platformArg);
  }

  Future<void> _invokePlatformMethodChannel(var arg) async {
    /// Response contain two parameter [isSuccess] [message]
    /// isSuccess return true when transaction is successfully and false when transaction is failed.
    /// on error its only contain  error message string but when success its contain response of transaction.

    var result;
    try {
      result =await platformChannel.invokeMethod("initiate_eSewa_gateway", arg);
    } on PlatformException catch(e){
    print(e);
    }

    if (result["isSuccess"]) {
      _purchaseStream.sink.add({
        "status": PaymentStatus.purchased,
        "data": result["message"],
      });
    } else {
      print(result["message"]);
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
