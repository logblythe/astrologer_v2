import 'package:astrologer/core/data_model/user_model.dart';
import 'package:astrologer/core/enum/gender.dart';
import 'package:astrologer/core/service/home_service.dart';
import 'package:astrologer/core/service/user_service.dart';
import 'package:astrologer/core/view_model/base_view_model.dart';

class ProfileViewModel extends BaseViewModel {
  final UserService _userService;
  final HomeService _homeService;
  bool accurateTime = false;
  Gender selectedGender;

  handleSwitch(value) => accurateTime = value;

  handleGenderSelection(gender) => selectedGender = gender;

  String _imageUrl;

  ProfileViewModel({UserService userService, HomeService homeService})
      : this._userService = userService,
        this._homeService = homeService {
    _homeService.init();
  }

  UserModel get user => _userService.user;

  get imageUrl => _imageUrl;

  getLoggedInUser() async {
    setBusy(true);
    accurateTime = user?.accurateTime;
    selectedGender = user?.gender == "M" ? Gender.male : Gender.female;
    setBusy(false);
  }

  Future<UserModel> updateUser(UserModel user) async {
    setBusy(true);
    bool newUser = user.userId == null;
    String deviceId = _homeService.deviceId;
    UserModel userModel =
        await _userService.updateUser(user, newUser, deviceId);
    setBusy(false);
    return userModel;
  }

  upload(imageFile) async {
    setUploadingImage(true);
    await _userService.upload(imageFile);
    setUploadingImage(false);
  }

  getImageUrl() async {
    _imageUrl = await _userService.getImageUrl();
  }
}
