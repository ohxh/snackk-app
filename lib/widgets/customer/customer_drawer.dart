import 'package:breve/widgets/customer/credit_cards/cards_page.dart';
import 'package:breve/widgets/general/breve_drawer.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';

class CustomerDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BreveDrawer(additionalOptions: [
      DrawerItem("Saved Cards", Icons.credit_card,
          Routes.willPush(context, CardsPage()))
    ]);
  }
}
