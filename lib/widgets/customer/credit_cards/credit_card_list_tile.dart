import 'package:breve/models/credit_card_preview.dart';
import 'package:breve/widgets/general/mini_loading_indicator.dart';
import 'package:flutter/material.dart';

class CreditCardListTile extends StatelessWidget {
  CreditCardPreview card;

  CreditCardListTile(this.card);

  @override
  Widget build(BuildContext context) {
    return card.isPushing
        ? ListTile(
            title: Text("Loading"),
            subtitle: Text("..."),
            trailing: Padding(
                padding: EdgeInsets.only(right: 14),
                child: MiniLoadingIndicator()))
        : ListTile(
            title: Text(card.brand + " ending in " + card.last4),
            subtitle: Text("expires " +
                card.expMonth +
                "/" +
                card.expYear.substring(2, 4)),
            trailing: IconButton(
                onPressed: () {
                  card.delete();
                },
                icon: Icon(Icons.close)));
  }
}
