import 'dart:async';

import 'package:astrologer/core/service/navigation_service.dart';
import 'package:astrologer/provider_setup.dart';
import 'package:astrologer/router.dart';
import 'package:astrologer/ui/shared/ui_helpers.dart';
import 'package:astrologer/ui/view/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchaseConnection.enablePendingPurchases();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Cosmos',
        color: Colors.red,
        theme: UIHelper.lightTheme
            .copyWith(textTheme: GoogleFonts.latoTextTheme(textTheme)),
        debugShowCheckedModeBanner: false,
        home: HomeView(),
        onGenerateRoute: (settings) => Routes.generateRoute(settings),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
