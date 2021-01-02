import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationHelper {
  AndroidInitializationSettings _initializationSettingsAndroid;

  IOSInitializationSettings _initializationSettingsIOS;
  InitializationSettings _initializationSettings;

  AndroidNotificationDetails _androidPlatformChannelSpecifics;
  IOSNotificationDetails _iOSPlatformChannelSpecifics;
  NotificationDetails _platformChannelSpecifics;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Function(String payload) _onSelectionNotification;

  Function(int id, String title, String body, String payload)
      _onReceiveLocalNotification;

  set onSelectionNotification(Function(String payload) value) {
    _onSelectionNotification = value;
  }

  set onReceiveLocalNotification(
      Function(int id, String title, String body, String payload) value) {
    _onReceiveLocalNotification = value;
  }

  LocalNotificationHelper() {
    // _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // _initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    // _initializationSettingsIOS = new IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    // _initializationSettings = new InitializationSettings(
    //     _initializationSettingsAndroid, _initializationSettingsIOS);
    // _flutterLocalNotificationsPlugin.initialize(_initializationSettings,
    //     onSelectNotification: onSelectNotification);
    // _androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //     'your channel id', 'your channel name', 'your channel description',
    //     importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    // _iOSPlatformChannelSpecifics = IOSNotificationDetails();
    // _platformChannelSpecifics = NotificationDetails(
    //     _androidPlatformChannelSpecifics, _iOSPlatformChannelSpecifics);
  }

  showNotification({@required String title, @required String body}) async {
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, _platformChannelSpecifics, payload: 'item x');
  }

  Future onSelectNotification(String payload) async {
    _onSelectionNotification(payload);
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    debugPrint('notification selected');
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    print('receive local notification');
    _onReceiveLocalNotification(id, title, body, payload);
    // display a dialog with the notification details, tap ok to go to another page
    /*showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              debugPrint('notification selected');
            },
          )
        ],
      ),
    );*/
  }
}
