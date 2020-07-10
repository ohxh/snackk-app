import 'package:snackk/widgets/general/breve_drawer.dart';
import 'package:snackk/widgets/restaurant/settings/shop_settings_page.dart';
import 'package:snackk/widgets/utils.dart';
import 'package:flutter/material.dart';

class RestaurantDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BreveDrawer(additionalOptions: [
      DrawerItem("Settings and hours", Icons.settings,
          Routes.willPush(context, ShopSettingsPage()))
    ]);
  }
}
