import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';

class CheckoutItem extends StatelessWidget {

String title;
void Function() onInfo;
int amount;
bool bold;

CheckoutItem(this.title, this.amount, {this.bold=false, this.onInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 36.0,
        child: ListTile(
          title: Row(children: [
            Text(
              title,
            style: TextStyles.largeLabel,
            ),
            if(onInfo != null) IconButton(
              icon: Icon(Icons.info, size: 20),
              onPressed: onInfo,
            )
          ]),
          trailing: Text(
            formatPrice(amount),
          ),
        ));
  }
}
