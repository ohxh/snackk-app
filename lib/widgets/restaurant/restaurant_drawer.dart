import 'package:breve/services/authentication.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/legal/legal_page.dart';
import 'package:breve/widgets/restaurant/settings/shop_settings_page.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  String name;
  IconData icon;
  Function action;

  DrawerItem (this.name, this.icon, this.action);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
            title: Row(children: [
              Icon(icon),
              Text('    ' + name),
            ]),
            onTap: action,
          );
  }
}

class BreveDrawer extends StatelessWidget {

 

  List<DrawerItem> additionalOptions;

  BreveDrawer(this.additionalOptions);

  @override
  Widget build(BuildContext context) {
     List<DrawerItem> options = [
   DrawerItem("Legal", Icons.info, Routes.willPush(context, LegalPage())),
   DrawerItem("Logout", Icons.exit_to_app, Auth.signOut)
   ];
        
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
                    (Auth.user as HasProfile).email,
                    style: TextStyles.whiteLabel,
                  ),
                  Text(
                     (Auth.user as HasProfile).name + (
                    !(Auth.user is Customer) ? (" (" + Auth.user.runtimeType.toString() + ")") : ""),
                    style: TextStyles.whiteLabel,
                  ),
                ]),
            decoration: BoxDecoration(color: BreveColors.black),
          ),
          ...additionalOptions,
          ...options
        ],
      ),
    );
  }
}
