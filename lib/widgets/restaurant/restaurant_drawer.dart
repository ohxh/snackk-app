import 'package:breve/services/authentication.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/legal/legal_page.dart';
import 'package:breve/widgets/restaurant/settings/shop_settings_page.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';

class RestaurantDrawer extends StatelessWidget {
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
                    Auth.user.email,
                    style: TextStyles.whiteLabel,
                  ),
                ]),
            decoration: BoxDecoration(color: BreveColors.black),
          ),
          ListTile(
            title: Row(children: [
              Icon(Icons.settings),
              Text('    Settings'),
            ]),
            onTap: Routes.willPush(context, ShopSettingsPage()) 
          ),
          ListTile(
            title: Row(children: [
              Icon(Icons.info),
              Text('    Legal'),
            ]),
            onTap: Routes.willPush(context, LegalPage())
          ),
          ListTile(
            title: Row(children: [
              Icon(Icons.exit_to_app),
              Text('    Logout'),
            ]),
            onTap: Auth.signOut
          ),
        ],
      ),
    );
  }
}
