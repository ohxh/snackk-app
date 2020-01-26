import 'package:flutter/material.dart';

class SelectableGroup<T> {
  List<T> options = new List();
  List<T> selection = new List();

  bool isLong = false;

  String name;
  String Function(T) getOptionName = (x) => x.toString(); 
  bool Function(T) isOptionLoading = (_) => false; 

  int min;
  int max;


  SelectableGroup.simple(this.name, this.options, {this.min=1, this.max=1, this.selection, this.isLong, this.getOptionName, this.onSelectionUpdate, this.isOptionLoading 
  });

  SelectableGroup.singleChoice({this.name, List<T> options, T value, bool canBeNone=true, this.isLong, this.getOptionName, void Function(T) onSelectionUpdate, this.isOptionLoading 
  }) {
    this.min = canBeNone ? 0 : 1;
    this.max = 1;
    this.onSelectionUpdate = (l) => onSelectionUpdate(l.isEmpty ? null : l.first);
    this.selection = value == null ? [] : [value];
    this.options = options ?? [];
  }

  String get selectionError {
    if(isValid) return "";
    if(min == 0 && max > 0) return "Select up to $max";
    if(min == max) return "Select $min";
    if(min > 0 && max > 0) return "Select $min to $max";
    return "error";
  }

  
  bool get isValid =>
    max != null && min != null &&
    selection.length >= min && (selection.length <= max || max == 0);

  void toggle(T option) {
      print("toggling " + option.toString());
    if(!selection.contains(option))
    {
    if (max == 1) selection=[option];
    else selection.add(option);
    }
    else  
    {
      if (min != 1) selection.remove(option);
    }
    onSelectionUpdate(selection);
  }

  bool hasSelected(T option) {
    print(option.hashCode.toString() + " == " + (selection.isEmpty ? "[]" : selection.first.hashCode.toString()));
    return selection.contains(option);}

  void Function(List<T>) onSelectionUpdate = (_){};
}
