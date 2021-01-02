import 'package:astrologer/core/validator_mixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeRow extends StatefulWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;
  final FocusNode timeFocusNode;
  final FocusNode dateFocusNode;
  final String initialDate;
  final String initialTime;

  const DateTimeRow(
      {Key key,
      this.dateController,
      this.timeController,
      this.timeFocusNode,
      this.dateFocusNode,
      this.initialDate,
      this.initialTime})
      : super(key: key);

  @override
  _DateTimeRowState createState() => _DateTimeRowState();
}

class _DateTimeRowState extends State<DateTimeRow> with ValidationMixing {
  DateTime date;
  TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          flex: 2,
          child: Container(
            margin: EdgeInsets.all(2),
            child: TextFormField(
              initialValue: widget.initialDate,
              readOnly: true,
              validator: isEmptyValidation,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(widget.timeFocusNode),
              focusNode: widget.dateFocusNode,
              onTap: () async {
                DateTime selectedDate = await showDatePicker(
                    context: context,
                    initialDate: currentDate,
                    firstDate: DateTime(1980),
                    lastDate: currentDate);
                setState(() {
                  if (selectedDate != null) date = selectedDate;
                });
                widget.dateController.text =
                    DateFormat("yyyy-MM-d").format(date);
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.calendar_today),
                isDense: true,
                labelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                labelText: 'Date of birth',
              ),
              maxLines: 1,
              controller: widget.dateController,
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          flex: 1,
          child: Container(
            margin: EdgeInsets.all(2),
            child: TextFormField(
              initialValue: widget.initialTime,
              readOnly: true,
              validator: isEmptyValidation,
              focusNode: widget.timeFocusNode,
              onTap: () async {
                TimeOfDay selectedTime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                setState(() {
                  if (selectedTime != null) {
                    time = selectedTime;
                    widget.timeController.text = DateFormat("hh:mm a").format(
                        DateFormat("HH:mm").parse(time.format(context)));
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Time',
                isDense: true,
                labelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              maxLines: 1,
              controller: widget.timeController,
            ),
          ),
        ),
      ],
    );
  }
}
