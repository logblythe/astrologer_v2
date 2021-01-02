import 'package:flutter/cupertino.dart';

class IdeaModel {
  IconData iconData;
  String title;
  List<String> children;

  IdeaModel(this.title, this.children, {this.iconData});
}
