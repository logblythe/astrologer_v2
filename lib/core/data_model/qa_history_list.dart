class QuestionAnswerHistory {
  String status;
  String engQuestion;
  String answer;
  String repliedBy;
  String profileImgUrl;

  QuestionAnswerHistory(
      {this.engQuestion, this.answer, this.repliedBy, this.profileImgUrl});

  QuestionAnswerHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    engQuestion = json['engQuestion'];
    answer = json['answer'];
    repliedBy = json['repliedBy'];
    profileImgUrl = json['profileImgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['engQuestion'] = this.engQuestion;
    data['answer'] = this.answer;
    data['repliedBy'] = this.repliedBy;
    data['profileImgUrl'] = this.profileImgUrl;
    return data;
  }
}
