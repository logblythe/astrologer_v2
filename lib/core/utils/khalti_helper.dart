import 'dart:async';

import 'package:flutter_khalti/flutter_khalti.dart';

enum PaymentStatus { pending, purchased, error }

class KhaltiHelper {
  StreamController<Map> _purchaseStream = StreamController.broadcast();
  FlutterKhalti _flutterKhalti;
  KhaltiProduct _product;

  get purchaseStream => _purchaseStream;

  KhaltiHelper() {
    _flutterKhalti = FlutterKhalti.configure(
      publicKey: "test_public_key_eacadfb91994475d8bebfa577b0bca68",
      urlSchemeIOS: "KhaltiPayFlutterExampleScheme",
      paymentPreferences: [KhaltiPaymentPreference.KHALTI],
    );

    _product = KhaltiProduct(
      id: "test",
      amount: 1000,
      name: "Hello Product",
    );
  }

  void makePayment() {
    _flutterKhalti.startPayment(
      product: _product,
      onSuccess: (data) {
        _purchaseStream.sink.add({
          "status": PaymentStatus.purchased,
          "data": data,
        });

      },
      onFaliure: (error) {
        _purchaseStream.sink.add({
          "status": PaymentStatus.error,
          "data": error,
        });
      },
    );
  }

  void dispose() {
    _purchaseStream.close();
  }
}
