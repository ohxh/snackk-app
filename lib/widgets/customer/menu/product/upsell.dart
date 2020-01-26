import 'package:breve/theme/theme.dart';
import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/material.dart';

class Upsell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
                    Padding(padding: EdgeInsets.only(left:24, right:24, bottom: 16), child: DashedContainer(
                    child: Container(
                      padding: Spacing.standard,
                      child: Center(child: Row(children: [Icon(Icons.add), SizedBox(width: 8), Text("Syrup", style: TextStyles.label), ])),
                      
                    ),
                    dashColor: BreveColors.darkGrey,
                    borderRadius: 16.0,
                    dashedLength: 8.0,
                    blankLength: 8.0,
                    strokeWidth: 2.0,
                  ));
  }
}