import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final bool busy;
  final Function onPress;
  final String label;

  const AnimatedButton({Key key, this.busy, this.onPress, this.label}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (Widget child, Animation<double> animation) =>
          ScaleTransition(child: child, scale: animation),
      duration: Duration(milliseconds: 250),
      child: widget.busy
          ? CircularProgressIndicator()
          : RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )
                ],
              ),
              onPressed: widget.onPress,
              color: Theme.of(context).primaryColor,
            ),
    );
  }
}
