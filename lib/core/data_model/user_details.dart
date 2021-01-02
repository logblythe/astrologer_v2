
class UserDetails {
  int userId;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String gender;
  String city;
  String state;
  String country;
  Object profileImageUrl;
  String dateOfBirth;
  String birthTime;
  bool accurateTime;

	UserDetails.fromJsonMap(Map<String, dynamic> map): 
		userId = map["userId"],
		firstName = map["firstName"],
		lastName = map["lastName"],
		email = map["email"],
		phoneNumber = map["phoneNumber"],
		gender = map["gender"],
		city = map["city"],
		state = map["state"],
		country = map["country"],
		profileImageUrl = map["profileImageUrl"],
		dateOfBirth = map["dateOfBirth"],
		birthTime = map["birthTime"],
		accurateTime = map["accurateTime"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['userId'] = userId;
		data['firstName'] = firstName;
		data['lastName'] = lastName;
		data['email'] = email;
		data['phoneNumber'] = phoneNumber;
		data['gender'] = gender;
		data['city'] = city;
		data['state'] = state;
		data['country'] = country;
		data['profileImageUrl'] = profileImageUrl;
		data['dateOfBirth'] = dateOfBirth;
		data['birthTime'] = birthTime;
		data['accurateTime'] = accurateTime;
		return data;
	}
}
