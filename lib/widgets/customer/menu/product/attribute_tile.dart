
import 'package:breve/models/product/specific_attribute.dart';
import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/menu/product/attribute_page.dart';
import 'package:breve/widgets/customer/wallet/select_chip.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
/*
class AttributeTile extends StatelessWidget {
  SpecificAttribute attribute;

  AttributeTile(this.attribute);

//#TODO: Add case for long attributes (old topping style)
  @override
  Widget build(BuildContext context) {
    bool isLong = attribute.base.options.length > 5;


      List<Widget> options = attribute.base.options.map((o) => 
        
        SelectChip(name: attribute.getOptionPrice(o) != null &&
                        attribute.getOptionPrice(o) > 0
                    ? o.name +
                        " (" +
                        NumberFormat.simpleCurrency()
                            .format(attribute.getOptionPrice(o) / 100) +
                        ")"
                    : o.name,
                    isSelected: attribute.hasSelected(o),
                    onTap: (_) => attribute.toggleOption(o))
        ).toList();

        List<Widget> selectedOptions = attribute.selection
        .map((o) => 
        
        SelectChip(name: attribute.getOptionPrice(o) != null &&
                        attribute.getOptionPrice(o) > 0
                    ? o.name +
                        " (" +
                        NumberFormat.simpleCurrency()
                            .format(attribute.getOptionPrice(o) / 100) +
                        ")"
                    : o.name,
                    icon: Icons.close,
                    isSelected: attribute.hasSelected(o),
                    onTap: (_) => attribute.toggleOption(o))
        ).toList();

      return ListTile(
          title: Row(children: [
            Text(attribute.base.name, style: TextStyles.largeLabel),
            SizedBox(width: 16),
            Text(attribute.selectionError(),
                style: TextStyle(color: Colors.red[800]))
          ]),
          trailing: isLong ? Icon(Icons.arrow_forward, color: Colors.black) : null,
          subtitle: isLong
              ? Wrap(runSpacing: -8, spacing: 6, children: selectedOptions)
              : Wrap(runSpacing: -8, spacing: 6, children: options),

          onTap: isLong
              ? Routes.willPush(context, AttributePage(attribute))
              : null);
    }
  
}
*/