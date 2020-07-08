import 'package:breve/models/restaurant.dart';
import 'package:breve/services/database.dart';
import 'package:breve/widgets/customer/restaurants/restaurant_search_bar.dart';
import 'package:breve/widgets/general/streamed_list_builder.dart';
import 'package:flutter/material.dart';

import 'restaurant_list_tile.dart';

class RestaurantList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RestaurantSearchBar(),
      QueryListBuilder(
          shrinkWrap: true,
          query: CustomerDatabase.instance.restaurantsRef,
          builder: (context, doc) {
            return RestaurantListTile(Restaurant.fromDocument(doc));
          })
      //
    ]);
  }

/*
  Widget carousel(BuildContext context) {
    if (_cafeList.length > 0) {
      return Container(
          height: 140,
          padding: EdgeInsets.only(top: 0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: false,
              itemCount: _cafeList.length,
              itemBuilder: (BuildContext context, int index) {
                Cafe cafe = _cafeList[index];
                return Padding(
                    padding: EdgeInsets.only(left: 12, bottom: 16, top: 8),
                    child: Column(children: [
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                              width: 200,
                              child: Stack(children: [
                                //background
                                Hero(
                                    tag: "background-" + cafe.id,
                                    child: Stack(children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage(cafe.image),
                                                  fit: BoxFit.cover),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              color: Colors.white,
                                              boxShadow: [
                                            BoxShadow(
                                                blurRadius: 10,
                                                color: Colors.black54,
                                                offset: Offset(0, 5))
                                          ])),
                                      Container(
                                          decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withAlpha(230),
                                              Colors.black.withAlpha(150),
                                              Colors.black.withAlpha(120),
                                              Colors.black.withAlpha(00)
                                            ],
                                            stops: [
                                              0,
                                              0.35,
                                              0.6,
                                              1
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        color: Colors.white,
                                      )),
                                    ])),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /*Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[Spacer(),IconButton(icon: Icon(Icons.favorite, color: Colors.white,size: 32)),],),*/
                                      Spacer(),
                                      Hero(
                                          tag: "title-" + cafe.name,
                                          child: Material(
                                              color: Colors.transparent,
                                              child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 0),
                                                  child: Text(cafe.name,
                                                      softWrap: true,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyles
                                                          .whiteLabel)))),
                                      SizedBox(height: 4),
                                      /* Divider(color: Colors.white,
                                                      thickness: 1, 
                                                      indent: 12, 
                                                      endIndent: ,),*/
                                      Hero(
                                          tag: "details-" + cafe.name,
                                          child: Row(children: [
                                            //
                                            Text(
                                                distances[cafe.id] == null
                                                    ? "..."
                                                    : distances[cafe.id]
                                                            .toStringAsFixed(
                                                                1) +
                                                        " miles",
                                                softWrap: true,
                                                textAlign: TextAlign.start,
                                                style:
                                                    TextStyles.whiteParagraph)
                                          ])),
                                    ],
                                  ),
                                )
                              ])),
                          /*onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RestaurantPage(_cafeList[index])));
                          },*/
                        ),
                      )
                    ]));
              }));
    } else {
      return SizedBox();
    }
  }*/

}
