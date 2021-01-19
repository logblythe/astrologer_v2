import 'package:flutter/material.dart';

class PaymentSelection extends StatelessWidget {
  final Function onKhaltiSelect;
  final Function onEsewaSelect;

  const PaymentSelection({Key key, this.onKhaltiSelect, this.onEsewaSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 180,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 16),
            Text('Select your payment option', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Divider(
              color: Theme.of(context).accentColor,
              height: 1,
              thickness: 1,
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  height: 100,
                  child: InkWell(
                    child: Image.asset('assets/images/ic-esewa.png'),
                    onTap: onEsewaSelect,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  height: 100,
                  child: InkWell(
                    child: Image.asset('assets/images/ic-khalti.png'),
                    onTap: onKhaltiSelect,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
