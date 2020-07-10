import 'package:snackk/theme/theme.dart';
import 'package:snackk/widgets/general/mini_loading_indicator.dart';
import 'package:flutter/material.dart';

class SelectChip extends StatelessWidget {
  String name;
  String id;
  void Function(bool) onTap;
  bool isSelected;
  bool isLoading;
  IconData icon;

  SelectChip(
      {this.name,
      this.id,
      this.isSelected,
      this.onTap,
      this.isLoading = false,
      this.icon}) {
    if (this.id == null) this.id = this.name;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? ChoiceChip(
            labelPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 0),
            backgroundColor: Colors.transparent,
            selectedColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: BreveColors.black, width: 1.5)),
            key: Key("Add"),
            label: MiniLoadingIndicator(),
            selected: false, //x,
            onSelected: (b) {},
          )
        : ChoiceChip(
            labelPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            backgroundColor: Colors.transparent,
            selectedColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: Colors.grey[900], width: 1.5)),
            key: Key(id),
            label: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(name,
                  style: TextStyle(
                    color: isSelected //x
                        ? Colors.white
                        : Colors.black,
                  )),
              if (icon != null) ...[
                Padding(
                    padding: EdgeInsets.only(top: 2, left: name == "" ? 0 : 4),
                    child: Icon(icon,
                        size: 16,
                        color: isSelected //x
                            ? Colors.white
                            : Colors.black))
              ]
            ]),
            selected: isSelected, //x,
            onSelected: (b) => onTap(isSelected));
  }
}
