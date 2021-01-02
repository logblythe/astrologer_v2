import 'package:astrologer/core/validator_mixin.dart';
import 'package:astrologer/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

class StateCityRow extends StatefulWidget {
  final FocusNode locationFocusNode;
  final FocusNode stateFocusNode;
  final TextEditingController locationController;
  final TextEditingController stateController;
  final String initialState;
  final String initialCity;

  const StateCityRow({
    Key key,
    this.locationFocusNode,
    this.stateFocusNode,
    this.locationController,
    this.stateController,
    this.initialState,
    this.initialCity,
  }) : super(key: key);

  @override
  _StateCityRowState createState() => _StateCityRowState();
}

class _StateCityRowState extends State<StateCityRow> with ValidationMixing {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          flex: 1,
          child: TextFormField(
            initialValue: widget.initialState,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(widget.locationFocusNode);
            },
            validator: isEmptyValidation,
            focusNode: widget.stateFocusNode,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_on),
              labelText: 'State',
              isDense: true,
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            maxLines: 1,
            controller: widget.stateController,
          ),
        ),
        UIHelper.horizontalSpaceSmall,
        Flexible(
          flex: 2,
          child: TextFormField(
            initialValue: widget.initialCity,
            validator: isEmptyValidation,
            focusNode: widget.locationFocusNode,
            decoration: InputDecoration(
              labelText: 'Location',
              isDense: true,
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            maxLines: 1,
            controller: widget.locationController,
          ),
        ),
      ],
    );
  }
}
