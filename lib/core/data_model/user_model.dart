class UserModel {
  int userId;
  String firstName;
  String lastName;
  String phoneNumber;
  String gender;
  String city;
  String state;
  String country;
  String role;
  String dateOfBirth;
  String birthTime;
  bool accurateTime;
  String errorMessage;
  String profileImageUrl;
  String deviceToken;

  UserModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.gender,
    this.city,
    this.state,
    this.country,
    this.role,
    this.dateOfBirth,
    this.birthTime,
    this.accurateTime,
    this.profileImageUrl,
    this.deviceToken,
  });

  UserModel.error({String error}) {
    errorMessage = error;
  }

  UserModel.fromError(Map<String, dynamic> json)
      : errorMessage = json['message'];

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        phoneNumber = json['phoneNumber'],
        gender = json['gender'],
        city = json['city'],
        state = json['state'],
        country = json['country'],
        role = json['role'],
        dateOfBirth = json['dateOfBirth'],
        birthTime = json['birthTime'],
        accurateTime = json['accurateTime'] ?? false,
        errorMessage = json['message'],
        profileImageUrl = json['profileImageUrl'],
        deviceToken = json['deviceToken'];

  UserModel.fromDb(Map<String, dynamic> json)
      : userId = json['userId'] as int,
        firstName = json['firstName'],
        lastName = json['lastName'],
        phoneNumber = json['phoneNumber'],
        gender = json['gender'],
        city = json['city'],
        state = json['state'],
        country = json['country'],
        role = json['role'],
        dateOfBirth = json['dateOfBirth'],
        birthTime = json['birthTime'],
        accurateTime = json['accurateTime'] == 1,
        deviceToken = json['deviceToken'],
        profileImageUrl = json['profileImageUrl'];

  Map<String, dynamic> toMapForDb() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "city": city,
        "state": state,
        "country": country,
        "role": role,
        "dateOfBirth": dateOfBirth,
        "birthTime": birthTime,
        "accurateTime": accurateTime,
        "profileImageUrl": profileImageUrl,
      };

  Map<String, dynamic> toMapForApi({String deviceId, String deviceToken}) => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "city": city,
        "state": state,
        "country": country,
        "role": role,
        "dateOfBirth": dateOfBirth,
        "birthTime": birthTime,
        "accurateTime": accurateTime,
        "profileImageUrl": profileImageUrl,
        "deviceId": deviceId,
        "deviceToken": deviceToken
      };

  @override
  String toString() {
    return toMapForDb().toString();
  }
}
