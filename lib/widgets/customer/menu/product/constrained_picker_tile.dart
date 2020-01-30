import 'package:breve/theme/theme.dart';
import 'package:breve/widgets/customer/menu/product/attribute_page.dart';
import 'package:breve/widgets/customer/menu/product/selectable_group.dart';
import 'package:breve/widgets/customer/wallet/select_chip.dart';
import 'package:breve/widgets/general/inline_error.dart';
import 'package:breve/widgets/general/listenable_rebuilder.dart';
import 'package:breve/widgets/utils.dart';
import 'package:flutter/material.dart';

class ConstrainedPickerTile<T> extends StatefulWidget {
  SelectableGroup<T> group;
  bool bigTitle;
  String Function(List<T>) trailValue;
  bool isLong;
  void Function() onAdd;
  String addText;
  
  ConstrainedPickerTile(this.group, {this.isLong=false, this.onAdd, this.bigTitle=false, this.trailValue, this.addText});

  @override
  _ConstrainedPickerTileState createState() => _ConstrainedPickerTileState<T>();
}

class _ConstrainedPickerTileState<T> extends State<ConstrainedPickerTile<T>> {
  @override
  Widget build(BuildContext context) {
  
    List<Widget> options = widget.isLong
        ? widget.group.selection
            .map((o) => SelectChip(
                name: widget.group.getOptionName == null ? o.toString() : widget.group.getOptionName(o),
                icon: Icons.close,
                isSelected: widget.group.hasSelected(o),
                onTap: (_) => widget.group.toggle(o)))
            .toList()
        : [...widget.group.options
            .map((o) => SelectChip(
                name: widget.group.getOptionName == null ? o.toString() : widget.group.getOptionName(o),
                isSelected: widget.group.hasSelected(o),
                isLoading: widget.group.isOptionLoading == null ? false : widget.group.isOptionLoading(o),
                onTap: (_) => widget.group.toggle(o)))
            .toList(), 
            if(widget.onAdd != null)
            SelectChip(name: widget.addText ?? "", icon: Icons.add, isSelected: false, onTap: (_) => widget.onAdd())];

    return ListTile(
        title: Row(children: [Wrap(children: [
          Text(widget.group.name, style: widget.bigTitle? TextStyles.largeLabel : TextStyle()),
          SizedBox(width: 16),
          InlineError(widget.group.selectionError), ]),
          Spacer(),
           widget.isLong
            ? Icon(Icons.arrow_forward, color: Colors.black)
            : (widget.trailValue != null ? Text(widget.trailValue(widget.group.selection)) : SizedBox()),
        ]),
        subtitle: Wrap(runSpacing: -8, spacing: 6, children: options),
        onTap: widget.isLong
            ? Routes.willPush(context, ConstrainedPickerPage(widget.group))
            : null);
    
  }
}
