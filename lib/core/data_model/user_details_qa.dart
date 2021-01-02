import 'package:astrologer/core/data_model/qa_history_list.dart';

class UserDetailsWithQA {
  int userId;
  String firstName;
  String lastName;
  String email;
  String gender;
  String city;
  String state;
  String country;
  String profileImageUrl;
  String dateOfBirth;
  String birthTime;
  String phoneNumber;
  bool accurateTime;
  List<QuestionAnswerHistory> questionAnswerHistoryList;

  UserDetailsWithQA(
      {this.userId,
        this.firstName,
        this.lastName,
        this.email,
        this.gender,
        this.city,
        this.state,
        this.country,
        this.profileImageUrl,
        this.dateOfBirth,
        this.birthTime,
        this.phoneNumber,
        this.accurateTime,
        this.questionAnswerHistoryList});

  UserDetailsWithQA.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    gender = json['gender'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    profileImageUrl = json['profileImageUrl'];
    dateOfBirth = json['dateOfBirth'];
    birthTime = json['birthTime'];
    phoneNumber = json['phoneNumber'];
    accurateTime = json['accurateTime'];
    if (json['questionAnswerHistoryList'] != null) {
      questionAnswerHistoryList = new List<QuestionAnswerHistory>();
      json['questionAnswerHistoryList'].forEach((v) {
        questionAnswerHistoryList
            .add(new QuestionAnswerHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['profileImageUrl'] = this.profileImageUrl;
    data['dateOfBirth'] = this.dateOfBirth;
    data['birthTime'] = this.birthTime;
    data['phoneNumber'] = this.phoneNumber;
    data['accurateTime'] = this.accurateTime;
    if (this.questionAnswerHistoryList != null) {
      data['questionAnswerHistoryList'] =
          this.questionAnswerHistoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
