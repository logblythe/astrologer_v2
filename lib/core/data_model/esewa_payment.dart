class ESewaPayment{
  /// actual cost of product price
  /// it is better to set price range 1-5 while testing.
  final double productPrice;

  /// this field takes product name that user want to buy.
  final String productName;

  /// this field is for uniquely generated [UUID] for unique identification of payment
  /// Note: [ProductId] must be unique for every payment user made.
  final String productId;

  /// [callBackUrl] for api call back.
  /// After successfully transaction between[User] and [Merchant] eSewa send copy of transaction to our server through url
  /// More info on [call-back] https://developer.esewa.com.np/#/android?id=call-back-url
  /// For Post api pattern checkout https://drive.google.com/drive/folders/1WWZiObktvXQHgOy_re6SnKLyyN8VSo9A
  /// Download callback url sdk and test in postman to know the pattern.
  final String callBackUrl;

  ESewaPayment({this.productPrice, this.productName, this.productId, this.callBackUrl});

  /// Mapping Payment to String Map
  Map<String,dynamic> toMap(ESewaPayment payment){
    Map<String,dynamic> map= Map<String,dynamic>();
    map["productPrice"] = "${payment.productPrice}";
    map["productName"] = payment.productName;
    map["productId"] = payment.productId;
    map["callBackUrl"] = payment.callBackUrl??"";
    return map;
  }
}