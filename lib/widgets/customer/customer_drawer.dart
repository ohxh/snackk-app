import 'package:breve/services/authentication.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/credit_cards/cards_page.dart';
import 'package:breve/widgets/customer/legal/legal_page.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';

class CustomerDrawer extends StatelessWidget {
  var user = Auth.status.value as LoggedIn;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.only(left: 24, bottom: 24),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.email,
                    style: TextStyles.whiteLabel,
                  ),
                ]),
            decoration: BoxDecoration( color: Colors.black),
          ),
          ListTile(
            title: Row(children: [
              Icon(Icons.credit_card),
              Text('    Saved Cards'),
            ]),
            onTap: Routes.willPush(context, CardsPage())
          ),
          ListTile(
            title: Row(children: [
              Icon(Icons.info),
              Text('    Legal'),
            ]),
            onTap: () {
              Routes.willPush(context, LegalPage());
            },
          ),
          ListTile(
            title: Row(children: [
              Icon(Icons.exit_to_app),
              Text('    Logout'),
            ]),
            onTap: () {
              Auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
