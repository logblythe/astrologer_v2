const String UNCLEAR = "unclear";
const String CLEAR = "clear";
const String UNASSIGNED = "unassigned";

class AstrologerModel {
  int userId;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String gender;
  String city;
  String state;
  String country;
  String role;
  String profileImageUrl;
  String error;

  AstrologerModel(
      {this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.gender,
      this.city,
      this.state,
      this.country,
      this.role,
      this.profileImageUrl});

  AstrologerModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        gender = json['gender'],
        city = json['city'],
        state = json['state'],
        country = json['country'],
        role = json['role'],
        profileImageUrl = json['profileImageUrl'];

/*  AstrologerModel.fromDb(Map<String, dynamic> json)
      : id = json['id'],
        text = json['message'],
        status = json['status'],
        sent = json['sent'] == 1,
        questionId = json["questionId"];*/

  Map<String, dynamic> toMapForDb() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "city": city,
        "state": state,
        "country": country,
        "role": role,
        "profileImageUrl": profileImageUrl,
        "error": error,
      };

  AstrologerModel.withError(String error) : error = error;

  @override
  String toString() {
    return toMapForDb().toString();
  }
}
