import 'package:astrologer/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class AccurateTimeSwitch extends StatefulWidget {
  final Function(bool value) onSwitch;
  final bool value;

  const AccurateTimeSwitch({
    Key key,
    this.onSwitch,
    this.value,
  }) : super(key: key);

  @override
  _AccurateTimeSwitchState createState() => _AccurateTimeSwitchState();
}

class _AccurateTimeSwitchState extends State<AccurateTimeSwitch> {
  bool _accurate;

  @override
  void initState() {
    super.initState();
    _accurate = widget.value;
  }

  @override
  void didUpdateWidget(AccurateTimeSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _accurate = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black45),
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.assignment_turned_in,
            color: Colors.black45,
          ),
          UIHelper.horizontalSpaceSmall,
          Expanded(
            child: SwitchListTile(
              contentPadding: EdgeInsets.all(0.0),
              title: const Text(
                'Accurate birth time',
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
              value: _accurate,
              onChanged: (bool value) {
                setState(() {
                  _accurate = value;
                });
                widget.onSwitch(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
