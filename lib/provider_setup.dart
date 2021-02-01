import 'package:astrologer/core/service/api.dart';
import 'package:astrologer/core/service/db_provider.dart';
import 'package:astrologer/core/service/home_service.dart';
import 'package:astrologer/core/service/navigation_service.dart';
import 'package:astrologer/core/service/user_service.dart';
import 'package:astrologer/core/utils/khalti_helper.dart';
import 'package:astrologer/core/utils/purchase_helper.dart';
import 'package:astrologer/core/utils/shared_pref_helper.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: Api()),
  Provider.value(value: SharedPrefHelper()),
  Provider.value(value: DbProvider()),
  Provider.value(value: NavigationService()),
  Provider.value(value: PurchaseHelper()),
  Provider.value(value: KhaltiHelper()),
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider3<Api, DbProvider, SharedPrefHelper, UserService>(
    update: (context, api, dbProvider, sharedPrefH, userService) => UserService(
      api: api,
      dbProvider: dbProvider,
      sharedPrefHelper: sharedPrefH,
    ),
  ),
  ProxyProvider5<Api, DbProvider, SharedPrefHelper, PurchaseHelper,
      KhaltiHelper, HomeService>(
    update: (context, api, dbProvider, sharedPrefH, purchaseHelper,
            khaltiHelper, homeService) =>
        HomeService(
            api: api,
            db: dbProvider,
            sharedPrefHelper: sharedPrefH,
            purchaseHelper: purchaseHelper,
            khaltiHelper: khaltiHelper),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<int>(
    initialData: 0,
    create: (context) =>
        Provider.of<HomeService>(context, listen: false).freeCountStream,
    updateShouldNotify: (_, __) => true,
  ),
  StreamProvider<String>(
    create: (context) =>
        Provider.of<UserService>(context, listen: false).profilePic,
    updateShouldNotify: (_, __) => true,
  ),
];
