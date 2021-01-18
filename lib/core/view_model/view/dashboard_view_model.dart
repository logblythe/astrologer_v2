import 'package:astrologer/core/constants/end_points.dart';
import 'package:astrologer/core/data_model/message_model.dart';
import 'package:astrologer/core/data_model/user_model.dart';
import 'package:astrologer/core/service/home_service.dart';
import 'package:astrologer/core/service/user_service.dart';
import 'package:astrologer/core/view_model/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class DashboardViewModel extends BaseViewModel {
  HomeService _homeService;
  UserService _userService;

  DashboardViewModel({
    @required HomeService homeService,
    @required UserService userService,
  })  : this._homeService = homeService,
        this._userService = userService;

  int _messageId;
  String _messageBox;
  bool _showSendBtn = true;
  bool _fetchingList = false;

  bool get fetchingList => _fetchingList;

  bool get showSendBtn => _showSendBtn;

  set showSendBtn(bool value) {
    _showSendBtn = value;
    notifyListeners();
  }

  String get messageBox => _messageBox;

  Stream<MessageAndUpdate> get nMsgStream => _homeService.nStream;

  void addMsgToSink(message, update) =>
      _homeService.addMsgToSink(message, update);

  List<MessageModel> get messages => _homeService.messages?.reversed?.toList();

  UserModel get user => _userService.user;

  getUserInfo() => _userService.getLoggedInUser();

  MessageModel _question;

  init() async {
    setBusy(true);
    _fetchingList = true;
    await _homeService.init();
    await _userService.getLoggedInUser();
    setupListeners();
    _fetchingList = false;
    setBusy(false);
  }

  void setupListeners() {
    nMsgStream.listen((MessageAndUpdate data) {
      _messageBox = data.message;
    });
    _homeService.purchaseHelper.purchaseStream.listen((purchaseStatus) {
      if (purchaseStatus == PurchaseStatus.pending) {
        //todo handle pending status
      } else if (purchaseStatus == PurchaseStatus.purchased) {
        setBusy(true);
        _homeService.makeQuestionRequest(_question).then((value) {
          setBusy(false);
        });
      } else if (purchaseStatus == PurchaseStatus.error) {
        updateQuestionStatusById(QuestionStatus.NOT_DELIVERED);
      }
    });
  }

  Future<void> addMessage(MessageModel message) async {
    _question = message;
    setBusy(true);
    _homeService.addMsgToSink("", true);
    _messageId = await _homeService.addMessage(_question);
    setBusy(false);
  }

  askQuestion(MessageModel message) async {
    setBusy(true);
    await _homeService.makeQuestionRequest(_question);
      if (_homeService.isFree) {
        await _homeService.makeQuestionRequest(_question);
      } else {
        bool nepali = await _homeService.isRequestFromNepal();
        if (nepali) {
          //use esewa or khalti
          print('the request is from nepal');
        } else {
          print('else the request is from nepal');
          _homeService.purchaseHelper.purchase();
        }
      }
      setBusy(false);
  }

  updateQuestionStatusById(String status) async {
    setBusy(true);
    await _homeService.updateQuestionStatusById(_messageId, status);
    setBusy(false);
  }
}
