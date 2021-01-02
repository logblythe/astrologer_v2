import 'package:astrologer/core/data_model/message_model.dart';
import 'package:astrologer/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  const MessageItem(
      {Key key,
      @required this.animation,
      this.onTap,
      @required this.item,
      this.selected: false,
      @required this.message,
      @required this.darkMode})
      : assert(animation != null),
        assert(item != null && item >= 0),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final int item;
  final bool selected;
  final MessageModel message;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline4;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Container(
      margin:
          message.sent ? EdgeInsets.only(left: 24) : EdgeInsets.only(right: 24),
      child: Column(
        children: <Widget>[
          // _buildQuestionId(),
          message.sent
              ? SizedBox.shrink()
              : message.astrologerUrl!=null && message.astrologerUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.network(
                        message.astrologerUrl,
                        height: 42,
                        width: 42,
                      ))
                  : CircleAvatar(
                      child: Text(message?.astrologer
                              ?.trim()
                              ?.substring(0, 1)
                              ?.toUpperCase() ??
                          "C"),
                    ),
          Padding(
            padding: message.sent ? EdgeInsets.zero : EdgeInsets.only(left: 20),
            child: _buildMessageColumn(context),
          ),
          _buildStatus(),
          UIHelper.verticalSpaceMedium,
        ],
        crossAxisAlignment:
            message.sent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      ),
    );
  }

  FadeTransition _buildMessageColumn(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(
          bottom: 2,
          top: 8,
          left: message.sent ? 32 : 0,
          right: message.sent ? 0 : 24,
        ),
        decoration: BoxDecoration(
            color: message.sent
                ? Theme.of(context).primaryColor.withOpacity(.2)
                : Colors.grey.withOpacity(.2),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(message.sent ? 0 : 12),
                topLeft: Radius.circular(message.sent ? 12 : 0),
                bottomLeft: Radius.circular(12),
                topRight: Radius.circular(12)),
            border: Border.all(
                color: message.sent
                    ? Theme.of(context).primaryColor.withOpacity(.5)
                    : Colors.grey)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                DateFormat("MMM d, yyyy hh:mm a").format(
                    DateTime.fromMillisecondsSinceEpoch(message.createdAt)),
                style: TextStyle(color: Colors.black54, fontSize: 10)),
            message.sent
                ? SizedBox.shrink()
                : Text(message.astrologer ?? "Cosmos astrology",
                    style: TextStyle(color: Colors.black54, fontSize: 10)),
            SizedBox(height: 8),
            Text(
              message.message ?? 'no message',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  FadeTransition _buildQuestionId() {
    return FadeTransition(
        opacity: animation,
        child: (message.sent)
            ? Text(message.questionId?.toString() ?? 'No question id',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
            : SizedBox.shrink());
  }

  FadeTransition _buildStatus() {
    return FadeTransition(
        opacity: animation,
        child: (message.sent)
            ? message.status == null
                ? SizedBox(
                    height: 8,
                    width: 8,
                    child: CircularProgressIndicator(strokeWidth: 1.0),
                  )
                : _getStatusWidget()
            : SizedBox.shrink());
  }

  Wrap _getStatusWidget() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.vertical,
      children: <Widget>[
        _getStatusIcon(),
        Text(message.status,
            style: TextStyle(
                color: message.status == NOT_DELIVERED
                    ? Colors.red
                    : Colors.black87,
                fontSize: 8,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _getStatusIcon() {
    switch (message.status) {
      case NOT_DELIVERED:
        return Icon(Icons.warning, color: Colors.redAccent);
      case DELIVERED:
        return Icon(Icons.check_circle, color: Colors.greenAccent);
      default:
        return SizedBox.shrink();
    }
  }
}
