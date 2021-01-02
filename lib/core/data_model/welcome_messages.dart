class WelcomeModel {
  List<String> welcomeMessages;

  WelcomeModel.fromJson(Map<String, dynamic> json)
      : welcomeMessages = json['messages'].cast<String>();
}
