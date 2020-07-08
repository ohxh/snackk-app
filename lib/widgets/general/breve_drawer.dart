import 'package:breve/services/authentication.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/general/support_page.dart';
import 'package:breve/widgets/legal/legal_page.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  String name;
  IconData icon;
  Function action;

  DrawerItem(this.name, this.icon, this.action);

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

  BreveDrawer({this.additionalOptions}) {
    if (this.additionalOptions == null) this.additionalOptions = [];
  }

  @override
  Widget build(BuildContext context) {
    List<DrawerItem> options = [
      DrawerItem("Support", Icons.headset_mic,
          Routes.willPush(context, SupportPage())),
      DrawerItem("Legal", Icons.info, Routes.willPush(context, LegalPage())),
      DrawerItem("Logout", Icons.exit_to_app, Auth.signOut)
    ];

    return Drawer(
      child: Column(
        children: [
          Expanded(
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.only(left: 24, bottom: 24, right: 12),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (Auth.user as HasProfile).email,
                      style: TextStyles.whiteLabel,
                    ),
                    SizedBox(height: 4),
                    Text(
                      (Auth.user as HasProfile).name +
                          (!(Auth.user is Customer)
                              ? (" (" + Auth.user.runtimeType.toString() + ")")
                              : ""),
                      style: TextStyles.whiteParagraph,
                    ),
                  ]),
              decoration: BoxDecoration(gradient: BreveColors.brandGradient),
            ),
            ...additionalOptions,
          ])),
          ...options ?? [],
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
