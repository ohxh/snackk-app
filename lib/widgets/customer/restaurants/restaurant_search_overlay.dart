
import 'package:breve/models/restaurant.dart';
import 'package:breve/services/database.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/restaurants/restaurant_list_tile.dart';
import 'package:flutter/material.dart';

class RestaurantSearchOverlay extends StatefulWidget {
  RestaurantSearchOverlay();

  @override
  _RestaurantSearchOverlayState createState() => new _RestaurantSearchOverlayState();
}

class _RestaurantSearchOverlayState extends State<RestaurantSearchOverlay> {
 // final formKey = new GlobalKey<FormState>();
 // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";


  @override
  void initState() { 
    super.initState();
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
         
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BreveColors.white,
      appBar: _buildBar(context),
      body: Container(child:
        StreamBuilder(stream: CustomerDatabase.instance.restaurantsRef.snapshots().map((doc) => doc.documents.map((res) => Restaurant.fromDocument(res)).toList()),
        
        builder: (context, list) => _buildList(list.data),
        )
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

  Widget _buildList(List<Restaurant> all) {
    List<Restaurant> filteredCafes = all;
    if (!(_searchText.isEmpty)) {
   
      List<Restaurant> tempList = new List();
      for (int i = 0; i < all.length; i++) {
       
        if (all[i].name.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(all[i]);
        }
      }
      filteredCafes = tempList;
    }
    return ListView.builder(
      itemCount: filteredCafes == null ? 0 : filteredCafes.length,
      itemBuilder: (BuildContext context, int index) {
        return RestaurantListTile(filteredCafes[index]);
          });
    
  }

}