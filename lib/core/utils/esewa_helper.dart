import 'dart:async';

import 'package:astrologer/core/data_model/esewa_payment.dart';
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

  StreamController<Map> _purchaseStream = StreamController.broadcast();

  get purchaseStream => _purchaseStream;

  Future<void> initPayment() async {
    // Unique Id for every payment invoke.
    var uuid = Uuid();
    var productId = uuid.v4();

    ESewaPayment payment = ESewaPayment(
        // Actual cost must be implement here.
        productPrice: 1.0,
        productName: "Astrology Question",
        productId: productId,
        callBackUrl: "");

    var _paymentDetails = ESewaPayment().toMap(payment);
    var _eSewaConfig = {
      "clientId": "$testClientId",
      "secretKey": "$testSecretKey",
      "environment": "$test"
    };

    var platformArg = [_eSewaConfig, _paymentDetails];
    await _invokePlatformMethodChannel(platformArg);
  }

  Future<void> _invokePlatformMethodChannel(var arg) async {
    /// Response contain two parameter [isSuccess] [message]
    /// isSuccess return true when transaction is successfully and false when transaction is failed.
    /// on error its only contain  error message string but when success its contain response of transaction.

    var result =
        await platformChannel.invokeMethod("initiate_eSewa_gateway", arg);

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
