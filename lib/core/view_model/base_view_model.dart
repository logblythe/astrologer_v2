import 'package:astrologer/core/enum/app_state.dart';
import 'package:astrologer/core/message_notifier_mixin.dart';
import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier with MessageNotifierMixin {
  bool _isDisposed = false;
  AppState _appState = AppState.IDLE;
  bool _uploadingImage = false;

  bool get busy => _appState == AppState.BUSY;

  bool get uploadingImage => _uploadingImage;

  bool get hasError => _appState == AppState.ERROR;

  String _errorMsg;

  String get errorMessage => _errorMsg;

  setUploadingImage(bool value) {
    _uploadingImage = value;
    notifyListeners();
  }

  void setBusy(bool value) {
    _appState = value ? AppState.BUSY : AppState.IDLE;
    if (!_isDisposed) notifyListeners();
  }

  void setError(String errorMsg) {
    _errorMsg = errorMsg;
    _appState = AppState.ERROR;
    notifyError(_errorMsg);
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
