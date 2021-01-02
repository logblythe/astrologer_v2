
class NotificationModel {
  Notification notification;
  Data data;

  NotificationModel({
    this.notification,
    this.data,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notification = json['notification'] != null
        ? new Notification.fromJson(Map.from(json['notification']))
        : null;
    data = json['data'] != null ? new Data.fromJson(Map.from(json['data'])) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Notification {
  String body;
  String title;

  Notification({this.body, this.title});

  Notification.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['title'] = this.title;
    return data;
  }
}

class Data {
  String engQuestionId;
  String status;
  String message;
  String repliedBy;
  String profileImgUrl;

  Data(
      {this.engQuestionId,
      this.status,
      this.message,
      this.repliedBy,
      this.profileImgUrl});

  Data.fromJson(Map<String, dynamic> json) {
    engQuestionId = json['engQuestionId'];
    status = json['status'];
    message = json['message'];
    repliedBy = json['repliedBy'];
    profileImgUrl = json['profileImgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['engQuestionId'] = this.engQuestionId;
    data['status'] = this.status;
    data['message'] = this.message;
    data['repliedBy'] = this.repliedBy;
    data['profileImgUrl'] = this.profileImgUrl;
    return data;
  }
}
