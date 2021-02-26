import 'package:flutter/services.dart';

class DatePickerHelper {
  /// [MethodChannel] invoke relation to native platform.
  /// Checkout for more info https://flutter.dev/docs/development/platform-integration/platform-channels?tab=ios-channel-objective-c-tab
  static const platformChannel = const MethodChannel("cosmos-date-picker");

  Future<String> invokePlatformMethodChannel() async {
    var result;
    try {
      result = await platformChannel.invokeMethod("init_date_piker_model");
    } on PlatformException catch (e) {
      print('e');
    }
    print(result);
    return result;
  }
}
