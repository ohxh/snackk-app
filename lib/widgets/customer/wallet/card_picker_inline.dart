import 'package:breve/services/database.dart';
import 'package:breve/widgets/customer/credit_cards/credit_card_modal.dart';
import 'package:breve/widgets/customer/menu/product/constrained_picker_tile.dart';
import 'package:breve/widgets/customer/menu/product/selectable_group.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:breve/models/credit_card_preview.dart';


class InlineCardPicker extends StatefulWidget {
  Function(String) onUpdated;

  
  InlineCardPicker({this.onUpdated});

  @override
  _InlineCardPickerState createState() => _InlineCardPickerState();
}

class _InlineCardPickerState extends State<InlineCardPicker> {
  CreditCardPreview selectedPaymentMethod;

  void onUpdate(CreditCardPreview s) {
    setState(() {
      selectedPaymentMethod = s;
      widget.onUpdated(s?.id);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: CustomerDatabase.instance.sourcesQuery.snapshots().map((q) =>
            q.documents.map((d) => CreditCardPreview.fromDocument(d)).toList()),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List<CreditCardPreview> cards = snapshot.data;
          print(cards);
          return ConstrainedPickerTile(
            
            SelectableGroup<CreditCardPreview>.singleChoice(name: "Credit card", options: cards, 
            value: selectedPaymentMethod,

            getOptionName: (CreditCardPreview c)=>c?.last4, isOptionLoading: (c)=>c?.isPushing, onSelectionUpdate: (l) => onUpdate(l)), 
            addText: cards?.length == 0 ? "Add credit card  " : null,
            onAdd: Routes.willPush(context, CreditCardModal()), bigTitle: true,
          );
              
        });
  }
}
