import 'package:astrologer/core/data_model/esewa_payment.dart';
import 'package:flutter/services.dart';

class ESewaHelper {
  /// [MethodChannel] invoke relation to native platform.
  /// Checkout for more info https://flutter.dev/docs/development/platform-integration/platform-channels?tab=ios-channel-objective-c-tab
  static const platformChannel= const MethodChannel("cosmos-eSewa");
  /// ESewa [Environments] are keys to switch between test and live server
  static const test = "ENVIRONMENT_TEST";
  static const live = "ENVIRONMENT_LIVE";

  static const testClientId = "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R";
  static const testSecretKey = "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==";

  Map<String, dynamic> initPayment(ESewaPayment payment) {
    // TODO : Environment must be change to live during deployment.
    var _paymentDetails = ESewaPayment().toMap(payment);
    var _eSewaConfig = {
      "clientId": "$testClientId",
      "secretKey": "$testSecretKey",
      "environment": "$test"
    };

    var platformArg=[
      _eSewaConfig,
      _paymentDetails
    ];
    _invokePlatformMethodChannel(platformArg);
    return {};
  }

  Future _invokePlatformMethodChannel(var arg) async{
    var result =await platformChannel.invokeMethod("initiate_eSewa_gateway",arg);
    print(result);
    return result;
  }
}
