import 'package:breve/models/menu/attribute.dart';
import 'package:breve/models/menu/may_segment_on_size.dart';
import 'package:breve/models/menu/option.dart';
import 'package:breve/models/product/specific_product.dart';
import 'package:breve/widgets/customer/menu/product/selectable_group.dart';
import 'package:collection/collection.dart';

class SpecificAttribute extends SelectableGroup<Option>{
  Attribute base;
  SpecificProduct product;

  SpecificAttribute.fromGeneric(Attribute atr, SpecificProduct product) 
  : super.simple(atr.name, atr.options, selection: List.from(atr.defaults), onSelectionUpdate: (_) => product.hasChanged())
  {
    this.base = atr;
    this.product = product;
  }

  SpecificAttribute.fromCached(Attribute atr, List<String> selection, SpecificProduct product) 
  : super.simple(atr.name, atr.options, selection: atr.options.where((a) => selection.map((x) => x.toLowerCase()).contains(a.name.toLowerCase())).toList(), onSelectionUpdate: (_) => product.hasChanged())
  {
    this.base = atr;
    this.product = product;
  }

  int get min => base.min.evaluate(product.size);
  int get max => base.max.evaluate(product.size);

  int price() => selection.fold(0, (p, o) => p + o.price.evaluate(product.size));

  bool valueIsDefault() {
    return ListEquality().equals(base.defaults, selection);}

  String toString() => 
  valueIsDefault() ? null :
  "$name: " + selection.map((x) => x.toString()).reduce((a,b) => "$a, $b");

  int getOptionPrice(Option o) => o.price.evaluate(product.size);

  String get selectionError {
    if(!isValid && product.size == null && (base.min is SegmentOnSize || base.max is SegmentOnSize)) return "Select a size";
    return super.selectionError;
  }
}