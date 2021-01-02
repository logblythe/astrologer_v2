import 'package:astrologer/core/data_model/user_details_qa.dart';

class UserHistory {
  List<String> welcomeMessages;
  UserDetailsWithQA userDetailsWithQA;

  UserHistory({this.welcomeMessages, this.userDetailsWithQA});

  UserHistory.fromJson(Map<String, dynamic> json) {
    welcomeMessages = json['welcomeMessages'].cast<String>();
    userDetailsWithQA = json['userDetailsWithQA'] != null
        ? new UserDetailsWithQA.fromJson(json['userDetailsWithQA'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['welcomeMessages'] = this.welcomeMessages;
    if (this.userDetailsWithQA != null) {
      data['userDetailsWithQA'] = this.userDetailsWithQA.toJson();
    }
    return data;
  }
}