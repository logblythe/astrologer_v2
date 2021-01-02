import 'package:flutter/material.dart';

class BottomSheetHelper {
  static void show(context, child) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return child;
      },
    );
  }
}
