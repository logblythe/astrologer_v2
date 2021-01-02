import 'package:astrologer/core/data_model/idea_model.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class IdeaItem extends StatelessWidget {
  const IdeaItem(this.entry, {this.onTap});

  final IdeaModel entry;

  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return _buildTilesN(context);
  }

  Widget _buildTilesN(context) {
    return Card(
      child: ExpandablePanel(
        iconColor: Theme.of(context).primaryColor,
        header: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              entry.title,
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.subtitle1,
            )),
        expanded: Column(
          children: entry.children
              .map((_child) => _buildString(_child, context))
              .toList(),
        ),
        tapHeaderToExpand: true,
        hasIcon: true,
      ),
    );
  }

  Widget _buildString(String str, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]))),
      padding: EdgeInsets.all(2),
      child: ListTile(
        title: Text(str, textScaleFactor: 0.9),
        trailing: IconButton(
          icon: Icon(
            Icons.send,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => onTap(str),
        ),
      ),
    );
  }
}
