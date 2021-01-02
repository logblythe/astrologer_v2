import 'package:astrologer/core/enum/gender.dart';
import 'package:flutter/material.dart';

class GenderTile extends StatelessWidget {
  final Gender character;
  final Function onTap;
  final String genderText;
  final IconData genderIcon;
  final bool isSelected;

  const GenderTile({
    Key key,
    @required this.character,
    @required this.onTap,
    @required this.genderText,
    @required this.genderIcon,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(genderIcon,
                color: (isSelected)
                    ? Theme.of(context).primaryColor
                    : Colors.grey),
            Text(
              genderText,
              style: (isSelected)
                  ? TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700)
                  : TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
