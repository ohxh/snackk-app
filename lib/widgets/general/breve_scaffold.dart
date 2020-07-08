import 'dart:collection';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:breve/theme/theme.dart';

class BreveScaffold extends StatefulWidget {
  Widget body;
  Widget floatingActionButton;
  List<Widget> tabs;
  String title;
  bool expanded;
  Brightness brightness;
  Widget drawer;
  List<Widget> trailing;
  GlobalKey<ScaffoldState> scaffoldKey;
  TabController tabController;
  Widget logo;
  bool scrollable;
  bool centerTitle;
  Color color;

  BreveScaffold(
      {@required this.body,
      @required this.title,
      this.floatingActionButton,
      this.tabs,
      this.expanded = false,
      this.drawer,
      this.brightness = Brightness.dark,
      this.scaffoldKey,
      this.trailing,
      this.tabController,
      this.logo,
      this.scrollable = true,
      this.centerTitle = false,
      this.color});

  BreveScaffold.withTabs(
      {@required Map<dynamic, Widget> content,
      @required this.title,
      this.floatingActionButton,
      this.expanded = false,
      this.drawer,
      this.brightness = Brightness.dark,
      this.scaffoldKey,
      this.trailing,
      this.tabController,
      this.logo,
      this.scrollable = true,
      this.centerTitle = false,
      this.color}) {
    List<Widget> parsed =
        content.keys.map((t) => t = t is Widget ? t : Tab(text: t)).toList();
    this.body = TabBarView(
      children: content.values.toList(),
      controller: tabController,
    );
    this.tabs = parsed.toList();
    print(tabController);
  }

  @override
  State<StatefulWidget> createState() => new _BreveScaffoldState();
}

class _BreveScaffoldState extends State<BreveScaffold> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    super.initState();
    if (widget.tabController != null)
      widget.tabController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    print(WidgetsBinding.instance.window.padding);
    if (widget.scaffoldKey == null) widget.scaffoldKey = new GlobalKey();
    return Stack(children: [
      Scaffold(
          primary: false,
          key: widget.key,
          drawer: widget.drawer,
          body: widget.body,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
                MediaQuery.of(context).padding.bottom +
                    (widget.tabs != null ? 136.0 : 80)),
            child: AppBar(
              brightness: widget.brightness,
              elevation: 0,
              backgroundColor: widget.brightness == Brightness.dark
                  ? BreveColors.black
                  : BreveColors.white,
              automaticallyImplyLeading: false,
              actions: widget.trailing,
              leading: Builder(
                  builder: (context) => widget.drawer != null
                      ? IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.menu,
                            color: widget.color ??
                                (widget.brightness == Brightness.dark
                                    ? BreveColors.white
                                    : BreveColors.black),
                          ))
                      : IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: widget.brightness == Brightness.dark
                                ? BreveColors.white
                                : BreveColors.black,
                          ))),
              centerTitle: widget.centerTitle,
              title: widget.logo ??
                  (widget.expanded
                      ? Text("")
                      : Text(widget.title,
                          style: TextStyle(
                              color: widget.brightness == Brightness.dark
                                  ? BreveColors.white
                                  : BreveColors.black,
                              fontWeight: FontWeight.w500))),
              bottom: widget.tabs != null
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(20),
                      child: Container(
                          padding: EdgeInsets.only(left: 8),
                          alignment: Alignment.topLeft,
                          color: Colors.white,
                          child: TabBar(
                            controller: widget.tabController,
                            isScrollable: true,
                            labelColor: BreveColors.black,
                            indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                    width: 2.0, color: BreveColors.black),
                                insets: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 12)),
                            unselectedLabelColor: BreveColors.darkGrey,
                            labelPadding: EdgeInsets.only(
                                left: 10, right: 10, top: 6, bottom: 7),
                            labelStyle: TextStyles.selectedTab,
                            unselectedLabelStyle: TextStyles.unselectedTab,
                            tabs: widget.tabs,
                          )))
                  : null,
            ),
          )),
      if (widget.floatingActionButton != null) widget.floatingActionButton
    ]);
  }
}
