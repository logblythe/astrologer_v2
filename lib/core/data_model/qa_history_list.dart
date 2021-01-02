class QuestionAnswerHistory {
  String engQuestion;
  String answer;
  String repliedBy;
  String profileImgUrl;

  QuestionAnswerHistory(
      {this.engQuestion, this.answer, this.repliedBy, this.profileImgUrl});

  QuestionAnswerHistory.fromJson(Map<String, dynamic> json) {
    engQuestion = json['engQuestion'];
    answer = json['answer'];
    repliedBy = json['repliedBy'];
    profileImgUrl = json['profileImgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['engQuestion'] = this.engQuestion;
    data['answer'] = this.answer;
    data['repliedBy'] = this.repliedBy;
    data['profileImgUrl'] = this.profileImgUrl;
    return data;
  }
}
