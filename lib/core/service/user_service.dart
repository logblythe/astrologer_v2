import 'dart:async';

import 'package:astrologer/core/data_model/image_model.dart';
import 'package:astrologer/core/data_model/user_model.dart';
import 'package:astrologer/core/service/api.dart';
import 'package:astrologer/core/service/db_provider.dart';
import 'package:astrologer/core/utils/shared_pref_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class UserService {
  final Api _api;
  final DbProvider _db;
  final SharedPrefHelper _sharedPrefHelper;

  final StreamController _streamController = StreamController<String>();

  Stream<String> get profilePic => _streamController.stream;

  UserModel _user;
  String _fcmToken;

  UserModel get user => _user;

  UserService({
    @required Api api,
    @required DbProvider dbProvider,
    @required SharedPrefHelper sharedPrefHelper,
  })  : _api = api,
        _db = dbProvider,
        _sharedPrefHelper = sharedPrefHelper {
    init();
  }

  init() async {
    _getFcmToken();
  }

  void _getFcmToken() async {
    if (_fcmToken == null) {
      _fcmToken = await FirebaseMessaging().getToken();
    }
    print('fcmtoken $_fcmToken');
  }

  Future<UserModel> getLoggedInUser() async {
    _user = await _db.getLoggedInUser();
    return _user;
  }

  Future<UserModel> updateUser(
      UserModel user, bool newUser, String deviceId) async {
    if (newUser) user.userId = 0;
    UserModel userModel = await _api.registerUser(user, deviceId, _fcmToken);
    if (userModel.errorMessage == null) {
      if (newUser) {
        _db.addUser(userModel);
      } else {
        _db.updateUser(userModel);
      }
    }
    _user = userModel;
    return userModel;
  }

  Future<ImageModel> upload(imageFile) async {
    ImageModel model = await _api.upload(imageFile);
    if (model != null) {
      _sharedPrefHelper.setString(KEY_IMAGE_URL, model.fileDownloadUri);
      _streamController.sink.add(model.fileDownloadUri);
    }
    return model;
  }

  getImageUrl() async {
    String imageUrl = await _sharedPrefHelper.getString(KEY_IMAGE_URL);
    if (imageUrl != null) {
      _streamController.sink.add(imageUrl);
    }
  }

  void dispose() {
    _streamController.close();
  }
}
