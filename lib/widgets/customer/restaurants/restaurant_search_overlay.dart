
import 'package:breve/models/restaurant.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/restaurants/restaurant_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';

class RestaurantSearchOverlay extends StatefulWidget {
  List<Restaurant> restaurants;
  RestaurantSearchOverlay(this.restaurants);

  @override
  _RestaurantSearchOverlayState createState() => new _RestaurantSearchOverlayState();
}

class _RestaurantSearchOverlayState extends State<RestaurantSearchOverlay> {
 // final formKey = new GlobalKey<FormState>();
 // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<Restaurant> filteredCafes = new List();

  _CafeSearchOverlayState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredCafes = widget.restaurants;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BreveColors.white,
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      title: Hero(tag: "search", child: 
      Material(color: Colors.transparent, child: TextField(
        autofocus: true,
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search...'
          ),
        ))),
        automaticallyImplyLeading: false,
      actions: [new IconButton(
        icon: Icon(Icons.close, color: Colors.black),
        onPressed: () {Navigator.pop(context);})]);

    
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
   
      List<Restaurant> tempList = new List();
      for (int i = 0; i < widget.restaurants.length; i++) {
       
        if (widget.restaurants[i].name.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(widget.restaurants[i]);
        }
      }
      filteredCafes = tempList;
    }
    return ListView.builder(
      itemCount: widget.restaurants == null ? 0 : filteredCafes.length,
      itemBuilder: (BuildContext context, int index) {
        return RestaurantListTile(filteredCafes[index]);
          });
      

  }



  void _getNames() async {
    setState(() {
      filteredCafes = widget.restaurants;
    });
  }


}