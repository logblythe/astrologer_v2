import 'package:astrologer/core/constants/end_points.dart';
import 'package:astrologer/core/data_model/astrologer_model.dart';
import 'package:astrologer/core/data_model/idea_model.dart';
import 'package:astrologer/core/data_model/message_model.dart';
import 'package:astrologer/core/data_model/qa_history_list.dart';
import 'package:astrologer/core/data_model/user_history.dart';
import 'package:astrologer/core/data_model/user_model.dart';
import 'package:astrologer/core/service/api.dart';
import 'package:astrologer/core/service/db_provider.dart';
import 'package:astrologer/core/utils/local_notification_helper.dart';
import 'package:astrologer/core/utils/purchase_helper.dart';
import 'package:astrologer/core/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:rxdart/rxdart.dart';

class HomeService {
  final DbProvider _dbProvider;
  final Api _api;
  final SharedPrefHelper _sharedPrefHelper;
  final LocalNotificationHelper _localNotificationHelper;
  final PurchaseHelper _purchaseHelper;

  int _prevQuesId;

  HomeService({
    @required DbProvider db,
    @required Api api,
    @required SharedPrefHelper sharedPrefHelper,
    @required LocalNotificationHelper localNotificationHelper,
    @required PurchaseHelper purchaseHelper,
  })  : _dbProvider = db,
        _api = api,
        _sharedPrefHelper = sharedPrefHelper,
        _localNotificationHelper = localNotificationHelper,
        _purchaseHelper = purchaseHelper;

  PublishSubject<MessageAndUpdate> _newMessage = PublishSubject();
  PublishSubject<int> _freeCountStream = PublishSubject();
  List<MessageModel> _messageList = [];
  List<AstrologerModel> _astrologers;
  UserModel _user;
  int _id, _freeCount;
  List<IdeaModel> _ideas;
  double _priceAfterDiscount;
  double _questionPrice;
  double _discountInPercentage;
  String _deviceId;

  String get deviceId => _deviceId;

  Stream<MessageAndUpdate> get nStream => _newMessage.stream;

  PurchaseHelper get purchaseHelper => _purchaseHelper;

  SharedPrefHelper get prefHelper => _sharedPrefHelper;

  get ideas => _ideas;

  Stream<int> get freeCountStream => _freeCountStream.stream;

  bool get isFree => _freeCount > 0;

  double get priceAfterDiscount => _priceAfterDiscount;

  double get questionPrice => _questionPrice;

  double get discountInPercentage => _discountInPercentage;

  addMsgToSink(String message, update) {
    _newMessage.sink.add(MessageAndUpdate(message, update));
  }

  addFreeCountToSink(int freeCount) {
    _freeCountStream.sink.add(freeCount);
  }

  List<MessageModel> get messages => _messageList;

//  List<MessageModel> get messages => [MessageModel(sent: false,message: "This is the received message",createdAt: DateTime.now().millisecondsSinceEpoch),MessageModel(sent: true,message: "this is the sent message",createdAt: DateTime.now().millisecondsSinceEpoch)];

  List<AstrologerModel> get astrologers => _astrologers;

  Future<void> initPlatformState() async {
    try {
      _deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      _deviceId = '';
    }
  }

  Future getFreeQuesCount() async {
    _freeCount = await _sharedPrefHelper.getInteger(KEY_FREE_QUES_COUNT) ?? 0;
    addFreeCountToSink(_freeCount);
  }

  Future<void> init() async {
    _messageList.clear();
    _user = await _dbProvider.getLoggedInUser();
    await initPlatformState();
    UserHistory history = await _api.fetchUserHistory(deviceId: _deviceId);
    if (_user == null && history.userDetailsWithQA != null) {
      UserModel user = UserModel(
        userId: history.userDetailsWithQA.userId,
        firstName: history.userDetailsWithQA.firstName,
        lastName: history.userDetailsWithQA.lastName,
        phoneNumber: history.userDetailsWithQA.phoneNumber,
        gender: history.userDetailsWithQA.gender,
        city: history.userDetailsWithQA.city,
        state: history.userDetailsWithQA.state,
        country: history.userDetailsWithQA.country,
        dateOfBirth: history.userDetailsWithQA.dateOfBirth,
        birthTime: history.userDetailsWithQA.birthTime,
        accurateTime: history.userDetailsWithQA.accurateTime,
        profileImageUrl: history.userDetailsWithQA.profileImageUrl,
      );
      _dbProvider.addUser(user);
    }
    List<String> welcomeMessage = history.welcomeMessages;
    welcomeMessage.forEach((element) {
      addMessage(MessageModel(message: element, sent: false));
    });
    List<QuestionAnswerHistory> qaList =
        history.userDetailsWithQA?.questionAnswerHistoryList;
    qaList?.forEach((qa) {
      addMessage(MessageModel(
        message: qa.engQuestion,
        sent: true,
        status: qa.answer.isNotEmpty ? DELIVERED : NOT_DELIVERED,
      ));
      addMessage(MessageModel(
          message: qa.answer,
          sent: false,
          astrologer: qa.repliedBy,
          astrologerUrl: qa.profileImgUrl));
    });
  }

  Future<int> addMessage(MessageModel message) async {
    message.createdAt = DateTime.now().millisecondsSinceEpoch;
    _id = await _dbProvider.addMessage(message);
    message.id = _id;
    _messageList.add(message);
    return _id;
  }

  updateQuestionStatusN(int questionId, String status) async {
    for (int i = 0; i < _messageList.length; i++) {
      if (_messageList[i].questionId == questionId) {
        _messageList[i].status = status;
        await _dbProvider.updateQuestionStatus(questionId, status);
        if (status == QuestionStatus.UNCLEAR) {
          _prevQuesId = questionId;
          _freeCount = _freeCount + 1;
          _sharedPrefHelper.setInt(KEY_FREE_QUES_COUNT, _freeCount);
          addFreeCountToSink(_freeCount);
        } else {
          _prevQuesId = null;
        }
      }
    }
  }

  Future<void> updateQuestionStatusById(int id, String status) async {
    print('Status $status $id');
    for (int i = 0; i < _messageList.length; i++) {
      print('at $i ${_messageList[i].toMapForDb()}');
      if (_messageList[i].id == id) {
        print('inside $i ${_messageList[i].toMapForDb()}');
        _messageList[i].status = status;
        await _dbProvider.updateQuestionStatusById(id, status);
      }
    }
  }

  void dispose() {
    _messageList.clear();
    _newMessage.close();
    _freeCountStream.close();
  }

  fetchAstrologers() async {
    if (_astrologers == null) _astrologers = await _api.fetchAstrologers();
  }

  fetchQuestionPrice() async {
    var result = await _api.fetchQuestionPrice();
    if (result != null) {
      _questionPrice = result['questionPrice'] ?? 0;
      _discountInPercentage = result['discountInPercentage'] ?? 0;
      _priceAfterDiscount =
          (100 - _discountInPercentage) / 100 * _questionPrice;
    }
  }

  showLocalNotification(String title, String body) async {
    await _localNotificationHelper.showNotification(title: title, body: body);
  }

  makeQuestionRequest(messageModel) async {
    _user = await _dbProvider.getLoggedInUser();
    Map<String, dynamic> messageResponse = await _api.askQuestion(
      _user.userId,
      messageModel.message,
      isFree ? 0 : _priceAfterDiscount,
      prevQuestionId: _prevQuesId,
    );
    if (messageResponse == null) {
      messageModel.status = NOT_DELIVERED;
    } else {
      messageModel.status = messageResponse['questionStatus'] ?? DELIVERED;
      messageModel.questionId = messageResponse['engQuesId'];
      if (isFree) {
        _freeCount = _freeCount - 1;
        await _sharedPrefHelper.setInt(KEY_FREE_QUES_COUNT, _freeCount);
        addFreeCountToSink(_freeCount);
      }
    }
    await _dbProvider.updateMessage(messageModel, _id);
  }
}

class MessageAndUpdate {
  String message;
  bool update;

  MessageAndUpdate(this.message, this.update);
}
