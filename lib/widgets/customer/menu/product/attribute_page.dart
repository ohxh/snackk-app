import 'package:snackk/models/menu/option.dart';
import 'package:snackk/models/product/specific_attribute.dart';
import 'package:snackk/theme/theme.dart';
import 'package:snackk/widgets/customer/menu/product/selectable_group.dart';
import 'package:snackk/widgets/general/breve_scaffold.dart';
import 'package:snackk/widgets/general/inline_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConstrainedPickerPage extends StatefulWidget {
  SelectableGroup group;
  void Function() onAdd;
  ConstrainedPickerPage(this.group, {this.onAdd});

  @override
  _ConstrainedPickerPageState createState() => _ConstrainedPickerPageState();
}

class _ConstrainedPickerPageState extends State<ConstrainedPickerPage> {
  Widget build(BuildContext context) {
    return BreveScaffold(
        title: widget.group.name,
        body: ListView(children: [
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: InlineError(widget.group.selectionError),
          ),
          ...widget.group.options
              .map((o) => ListTile(
                    title: Text(widget.group.getOptionName == null
                        ? o.toString()
                        : widget.group.getOptionName(o)),
                    trailing: Checkbox(
                        onChanged: (_) =>
                            setState(() => widget.group.toggle(o)),
                        value: widget.group.hasSelected(o)),
                    onTap: () => setState(() => widget.group.toggle(o)),
                  ))
              .toList(),
          if (widget.onAdd != null)
            ListTile(
                title: Text("Add"),
                trailing: Icon(Icons.add),
                onTap: widget.onAdd)
        ]));
  }
}
