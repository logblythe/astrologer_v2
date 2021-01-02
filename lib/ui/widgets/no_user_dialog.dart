import 'package:astrologer/ui/shared/route_paths.dart';
import 'package:astrologer/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class NoUserDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image.asset(
              "assets/images/ic_question.png",
              height: 160,
            ),
          ),
          UIHelper.verticalSpaceMedium,
          Text(
            'Information required!',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          UIHelper.verticalSpaceSmall,
          Text(
            "Please provide us your information so that we can make accurate predictions",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Theme.of(context).disabledColor,
                fontWeight: FontWeight.w400),
          ),
          UIHelper.verticalSpaceSmall,
          Align(
            alignment: Alignment.bottomRight,
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                color: Theme.of(context).primaryColor,
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RoutePaths.profile);
                }),
          )
        ],
      ),
    );
  }
}
