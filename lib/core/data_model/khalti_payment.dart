import 'package:flutter/cupertino.dart';

class KhaltiPayment {
  final String publicKey;

  final String productName;

  final int amount;

  final String productId;

  final String productUrl;

  final bool eBankingPayment;

  KhaltiPayment(
      {@required this.publicKey,
      @required this.productName,
      @required this.amount,
      @required this.productId,
      this.productUrl,
      this.eBankingPayment});

  /// Mapping Payment to String Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["publicKey"] = this.publicKey;
    map["productName"] = this.productName;
    map["amount"] = "${this.amount}";
    map["productId"] = this.productId;
    map["productUrl"] = this.productUrl ?? "";
    map["eBankingPayment"] = "${this.eBankingPayment?? false}";
    return map;
  }
}
