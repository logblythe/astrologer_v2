import 'package:astrologer/connectivity_mixin.dart';
import 'package:astrologer/core/data_model/notification_model.dart';
import 'package:astrologer/core/view_model/view/home_view_model.dart';
import 'package:astrologer/ui/base_widget.dart';
import 'package:astrologer/ui/shared/route_paths.dart';
import 'package:astrologer/ui/shared/ui_helpers.dart';
import 'package:astrologer/ui/view/ideas_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'astrologers_view.dart';
import 'dashboard_view.dart';

final List<Map<String, dynamic>> _children = [
  {
    'title': 'Cosmos',
    'action': Icons.person_pin,
  },
  {'title': 'Astrologers'},
  {'title': 'Ideas to ask'},
  {'title': 'Settings'},
];

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with ConnectivityMixin {
  PageController _pageController;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  HomeViewModel _homeViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      model: _homeViewModel,
      onModelReady: (_homeViewModel) async {
        _homeViewModel.getFreeQuesCount();
        _homeViewModel.getLoggedInUser();
        _homeViewModel.fetchQuestionPrice();
        initConnectivity(_homeViewModel);
      },
      builder: (context, HomeViewModel model, _) => Scaffold(
        drawer: _buildDrawer(model),
        appBar: AppBar(
          elevation: 0,
          title: titleWidget(model),
          actions: <Widget>[_buildIconButton(model)],
        ),
        body: _buildWillPopScope(model),
      ),
    );
  }

  titleWidget(model) {
    if (model.index == 0) {
      return Container(
          padding: EdgeInsets.all(32),
          child: Image.asset('assets/images/app_bar.png'));
    } else {
      return Text(_children[model.index]['title']);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async =>
          _onNotificationReceived(message),
      onLaunch: (Map<String, dynamic> message) async =>
          _onNotificationReceived(message),
      onResume: (Map<String, dynamic> message) async =>
          _onNotificationReceived(message),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeViewModel = HomeViewModel(
      userService: Provider.of(context),
      homeService: Provider.of(context),
    );
  }

  void _onNotificationReceived(Map<String, dynamic> message) async {
    NotificationModel notification = NotificationModel.fromJson(message);
    await _homeViewModel.onNotificationReceived(notification);
    _listKey.currentState.insertItem(0, duration: Duration(milliseconds: 500));
  }

  IconButton _buildIconButton(HomeViewModel model) {
    return IconButton(
      icon: Icon(_children[model.index]['action']),
      onPressed: () async {
        switch (model.index) {
          case 0:
            Navigator.pushNamed(context, RoutePaths.profile);
            break;
        }
      },
    );
  }

  WillPopScope _buildWillPopScope(HomeViewModel model) {
    return WillPopScope(
      onWillPop: () => _onWillPop(model),
      child: Stack(
        children: <Widget>[
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: _pageViewChildren(model),
            scrollDirection: Axis.horizontal,
          ),
          model.internetConnection
              ? Container()
              : AnimatedContainer(
                  duration: Duration(milliseconds: 2000),
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(16),
                    type: MaterialType.card,
                    animationDuration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('NO INTERNET CONNECTION'),
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Future<bool> _onWillPop(HomeViewModel model) {
    if (model.index != 0) {
      model.index = 0;
      _pageController.jumpTo(0);
      return null;
    } else {
      return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit an App'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No'),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }
  }

  List<Widget> _pageViewChildren(HomeViewModel model) {
    return [
      DashboardView(listKey: _listKey),
      AstrologersView(),
      IdeasView(
        onTap: (idea) => _handleIdeaSelection(model, idea),
      ),
    ];
  }

  Drawer _buildDrawer(HomeViewModel model) {
    final freeCount = Provider.of<int>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              height: 160,
              child: Image.asset(
                "assets/images/nav_bar.jpg",
                fit: BoxFit.fitHeight,
              )),
          Container(
            color: Theme.of(context).primaryColor,
            child: ListTile(
              title:
                  Text('Free questions', style: TextStyle(color: Colors.white)),
              trailing: Text(freeCount != null ? freeCount?.toString() : "-",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Question price',
                      style: TextStyle(color: Colors.white)),
                ),
                model.discountInPercentage == null
                    ? Container()
                    : model.discountInPercentage.toInt() > 0
                        ? RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: '\$ ${model.priceAfterDiscount}\n',
                                    style: TextStyle(height: 1.5)),
                                TextSpan(
                                  text: ' \$ ${model.questionPrice} ',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        '  (${model.discountInPercentage}% off)  ',
                                    style: TextStyle(color: Colors.black45)),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('\$ ${model.priceAfterDiscount}'),
                          )
              ],
            ),
          ),
          ListTile(
              title: Text('About Astrology',
                  style: TextStyle(color: Theme.of(context).disabledColor))),
          ListTile(
            title: Text(
              'Dashboard',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            leading: Icon(Icons.developer_board),
            onTap: () => _onDrawerTap(model, 0),
          ),
          ListTile(
            title: Text(
              'Astrologers',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            leading: Icon(Icons.people),
            onTap: () => _onDrawerTap(model, 1),
          ),
          ListTile(
            title: Text(
              'What to ask?',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            leading: Icon(Icons.help),
            onTap: () => _onDrawerTap(model, 2),
          ),
          ListTile(
            title: Text('Why Cosmos?'),
            leading: Icon(Icons.business_center),
            onTap: _showWhyCosmosDialog,
          ),
          ListTile(
              title: Text(
                  'Our mission is to make Cosmic astrology accessible to all people to help them attain positive changes in their lives.',
                  style: Theme.of(context).textTheme.bodyText1)),
        ],
      ),
    );
  }

  void initConnectivity(HomeViewModel model) {
    initializeConnectivity(onConnected: () {
      model.internetConnection = true;
    }, onDisconnected: () {
      model.internetConnection = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  void _onDrawerTap(HomeViewModel model, int index, {bool shouldPop = true}) {
    FocusScope.of(context).requestFocus(FocusNode());
    model.index = index;
    _pageController.jumpToPage(model.index);
    if (shouldPop) {
      Navigator.pop(context);
    }
  }

  _handleIdeaSelection(HomeViewModel model, String message) {
    model.addMessageSink(message);
    model.index = 0;
    _pageController.jumpToPage(0);
  }

  _showWhyCosmosDialog() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  "Why Cosmos?",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
                UIHelper.verticalSpaceMedium,
                Text(
                  "Astrology claims divine information about human affairs and terrestrial events by studying the movements and relative positions of celestial bodies.It still needs more study and research about astrology however based on our learning and research we find the influence of other celestial bodies on earth as well as on us. With the natal chart we can analyse the influence of planets on us,how they support us and what effects can be seen. Cosmos helps to judge relationship compatibility, understand friendship dynamics and make life decisions.",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
