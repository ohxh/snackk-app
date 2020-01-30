import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:breve/theme/theme.dart';


class BreveScaffoldExpanded extends StatefulWidget {

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

  BreveScaffoldExpanded({@required this.body, @required this.title, this.floatingActionButton, this.tabs, this.expanded = false, this.drawer, this.brightness = Brightness.dark, this.scaffoldKey, this.trailing, this.tabController, this.logo, this.scrollable=true});

 @override
  State<StatefulWidget> createState() => new _BreveScaffoldExpandedState();
}

class _BreveScaffoldExpandedState extends State<BreveScaffoldExpanded> {
  @override 
  void initState() {
    super.initState();
    if(widget.tabController != null)
    widget.tabController.addListener(() => setState(() {
    }));
  }
  @override
  Widget build(BuildContext context) {
  
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    if(widget.scaffoldKey == null) widget.scaffoldKey = new GlobalKey();
    return 
    
    Stack(children: [Scaffold(
      primary: false,
      key: widget.key,
      drawer: widget.drawer,
      
        body: NestedScrollView(
          
        physics: widget.scrollable ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        brightness: widget.brightness,
                        elevation: 0,
                  backgroundColor: widget.brightness == Brightness.dark ? BreveColors.black : BreveColors.white,
                        automaticallyImplyLeading: false,
                        actions: widget.trailing,
                        leading: widget.drawer!=null ? IconButton(
                          onPressed: () {Scaffold.of(context).openDrawer();
                          setState(() {
                            
                          }
                        
                          );},
                            icon: Icon(
                          Icons.menu,
                          color: widget.brightness == Brightness.dark ? BreveColors.white : BreveColors.black,
                          
                        )) :IconButton(
                          onPressed: (){Navigator.pop(context);},
                            icon: Icon(
                          Icons.arrow_back,
                          color: widget.brightness == Brightness.dark ? BreveColors.white : BreveColors.black,
                        )),
                        centerTitle: true,
                        
                        title: widget.logo != null ? widget.logo : (widget.expanded ? Text("") : Text(widget.title, style: TextStyle(color: widget.brightness == Brightness.dark ? BreveColors.white : BreveColors.black, fontWeight: FontWeight.w600))),
                        floating: false,
                        pinned: !widget.expanded,
                      ),
                      if(widget.expanded) 
                      SliverAppBar(
                       backgroundColor: widget.brightness == Brightness.dark ? BreveColors.black : BreveColors.white,
                        automaticallyImplyLeading: false,
                        centerTitle: false,
                        title: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(widget.title, style: widget.brightness == Brightness.dark ? TextStyles.whiteHeading : TextStyles.heading)),
                        floating: false,
                        pinned: false,
                      ),
                    if(widget.expanded) 
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverSpacerDelegate(
                          
                          minHeight: statusBarHeight,
                          maxHeight: statusBarHeight,
                          child: Container(
                            color: widget.brightness == Brightness.dark ? BreveColors.black : BreveColors.white,
                          ),
                        ),
                      ),
                      if (widget.tabs != null && widget.tabs.length > 0) 
                          SliverPersistentHeader(
                              delegate: _SliverAppBarDelegate(
          
                                TabBar(
                                  controller: widget.tabController,
                        isScrollable: true,
                        
                        labelColor: BreveColors.black,
                        indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                                width: 2.0, color: BreveColors.black),
                            insets:
                                EdgeInsets.only(left: 16, right: 0, bottom: 12)),
                        unselectedLabelColor: BreveColors.darkGrey,
                        labelPadding: EdgeInsets.only(
                            left: 16, right: 0, top: 8, bottom: 10),
                        labelStyle: TextStyles.selectedTab,
                        unselectedLabelStyle: TextStyles.unselectedTab,
                        tabs: widget.tabs,
                      ),
                    ),
                    pinned: true,
                    
                  ) 
          ];
        },
        body: widget.body,
      ),
    ),
    if(widget.floatingActionButton != null) widget.floatingActionButton]);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + 12;
  @override
  double get maxExtent => _tabBar.preferredSize.height + 12;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [BreveColors.white, BreveColors.white, Color(0x00FFFFFF)],
              stops: [0, 1, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _SliverSpacerDelegate extends SliverPersistentHeaderDelegate {
  _SliverSpacerDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverSpacerDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
