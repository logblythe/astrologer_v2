import 'package:astrologer/core/data_model/message_model.dart';
import 'package:astrologer/core/data_model/notification_model.dart';
import 'package:astrologer/core/data_model/user_model.dart';
import 'package:astrologer/core/service/home_service.dart';
import 'package:astrologer/core/service/user_service.dart';
import 'package:astrologer/core/view_model/base_view_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends BaseViewModel {
  final HomeService _homeService;
  final UserService _userService;
  int _index = 0;
  bool _internetConnection = true;

  bool get internetConnection => _internetConnection;

  set internetConnection(bool value) {
    _internetConnection = value;
    notifyListeners();
  }

  double get priceAfterDiscount => _homeService.priceAfterDiscount;

  double get questionPrice => _homeService.questionPrice;

  double get discountInPercentage => _homeService.discountInPercentage;

  HomeViewModel(
      {@required HomeService homeService, @required UserService userService})
      : _homeService = homeService,
        _userService = userService;

  int get index => _index;

  UserModel get userModel => _userService.user;

  set index(int value) {
    _index = value;
    notifyListeners();
  }

  getLoggedInUser() => _userService.getLoggedInUser();

  addMessageSink(String message) {
    _homeService.addMsgToSink(message, true);
  }

  onNotificationReceived(NotificationModel answer) async {
    var data = answer.data;
    if (answer.data.message != null) {
      await _homeService.addMessage(MessageModel(
          sent: false,
          status: data.status,
          message: data.message,
          questionId: 0,
          astrologer: data.repliedBy));
    }
    await _homeService.updateQuestionStatusN(
        int.parse(data.engQuestionId), data.status);
  }

  getFreeQuesCount() => _homeService.getFreeQuesCount();

  fetchQuestionPrice() async {
    setBusy(true);
    await _homeService.fetchQuestionPrice();
    setBusy(false);
  }

  showLocalNotification(String title, String body) async =>
      await _homeService.showLocalNotification(title, body);
}
