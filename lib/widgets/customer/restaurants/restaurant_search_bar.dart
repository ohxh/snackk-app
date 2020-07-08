import 'package:breve/effects/slide_up_transition.dart';
import 'package:breve/widgets/customer/restaurants/restaurant_search_overlay.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';

class RestaurantSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 0),
          child: GestureDetector(
            child: Container(
              color: Colors.white,
              child: Hero(
                tag: "search",
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    autofocus: false,
                    decoration: new InputDecoration(
                        /*disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),*/
                        prefixIcon: new Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        hintText: 'Search...'),
                    enabled: false,
                  ),
                ),
              ),
            ),
            onTap: () => Navigator.push(context, 
            SlideUpRoute(page: 
            RestaurantSearchOverlay())))
            
          );
  }
}