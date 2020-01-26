import 'package:breve/widgets/general/badge.dart';
import 'package:flutter/material.dart';


class AllergyIcons extends StatelessWidget {

  List<String> attributes;  

  AllergyIcons(this.attributes);


  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: attributes.map((a) =>
    Padding(padding: EdgeInsets.only(left: 6), child: Badge(color: Colors.grey, text: a))
    ).toList());
  }
}