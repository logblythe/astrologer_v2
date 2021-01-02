import 'package:astrologer/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class NoMessageWidget extends StatelessWidget {
  final String buttonTitle;
  final Function buttonTap;

  const NoMessageWidget({Key key, this.buttonTitle, this.buttonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UIHelper.verticalSpaceMedium,
              Image.asset('assets/images/ic_we.png', height: 160),
              Text("Welcome to COSMOS!",
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(height: 4),
              Text(
                "With cosmos, you can put your queries related to astrology and get clear instructions from our astrologers.",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).disabledColor,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "You can start right away by starting the conversation, after entering your credentials into our system",
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
                      buttonTitle,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                    onPressed: buttonTap),
              )
            ],
          ),
        ),
      ),
    );
  }
}