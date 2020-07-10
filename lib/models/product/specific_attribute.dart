import 'dart:math';

import 'package:snackk/models/menu/attribute.dart';
import 'package:snackk/models/menu/may_segment_on_size.dart';
import 'package:snackk/models/menu/option.dart';
import 'package:snackk/models/product/specific_product.dart';
import 'package:snackk/widgets/customer/menu/product/selectable_group.dart';
import 'package:snackk/widgets/utils.dart';
import 'package:collection/collection.dart';

class SpecificAttribute extends SelectableGroup<Option> {
  Attribute base;
  SpecificProduct product;

  SpecificAttribute.fromGeneric(Attribute atr, SpecificProduct product)
      : super.simple(atr.name, atr.options,
            selection: List.from(atr.defaults),
            onSelectionUpdate: (_) => product.hasChanged()) {
    this.base = atr;
    this.product = product;
  }

  String get name => super.name;

  SpecificAttribute.fromCached(
      Attribute atr, List<String> selection, SpecificProduct product)
      : super.simple(atr.name, atr.options,
            selection: atr.options
                .where((a) => selection
                    .map((x) => x.toLowerCase())
                    .contains(a.name.toLowerCase()))
                .toList(),
            onSelectionUpdate: (_) => product.hasChanged()) {
    this.base = atr;
    this.product = product;
  }

  int get min => base.min.evaluate(product.size);
  int get max => base.max.evaluate(product.size);

  int get defaultPrice {
    var res = base.defaults
        .fold<int>(0, (p, o) => p + o.price.evaluate(product.size));
    return res;
  }

  int price() {
    return (selection.fold(0, (p, o) => p + o.price.evaluate(product.size)) -
            defaultPrice)
        .clamp(0, double.infinity);
  }

  int rawPrice() {
    return selection.fold(0, (p, o) => p + o.price.evaluate(product.size));
  }

  bool valueIsDefault() {
    return ListEquality().equals(base.defaults, selection);
  }

  String toString() => valueIsDefault()
      ? ""
      : "${super.name}: " +
          (selection.length > 0 ? selection.join(", ") : " none");

  bool allSameCost() => this.options.fold(
      true,
      (a, b) =>
          a &&
          b.price.evaluate(product.size) ==
              options[0].price.evaluate(product.size));

  int getOptionPrice(Option o) => o.price.evaluate(product.size);

  String getOptionName(Option o) {
    var priceEffect =
        (rawPrice() - defaultPrice).clamp(double.negativeInfinity, 0);
    int acc = defaultPrice;

    Map<Option, int> priceEffects = Map();

    selection.map((x) {
      if (getOptionPrice(x) == null) {
        priceEffects[x] = null;
      } else {
        var amount = getOptionPrice(x).clamp(0, acc);
        acc -= amount;
        priceEffects[x] = getOptionPrice(x) - amount;
      }
    }).toList();

    if (max == 1 && selection.length == 1 && defaultPrice != null) {
      acc += defaultPrice.clamp(0, getOptionPrice(selection[0]));
    }

    if (selection.contains(o)) {
      if (priceEffects[o] == 0) return o.name;
      if (priceEffects[o] == null) return o.name + " (\$)";
      return o.name + " (" + formatPrice(priceEffects[o]) + ")";
    } else {
      var priceEffect = getOptionPrice(o) == null
          ? null
          : (getOptionPrice(o) - acc).clamp(0, double.infinity);
      if (priceEffect == 0) return o.name;
      if (priceEffect == null) return o.name + " (\$)";
      return o.name + " (" + formatPrice(priceEffect) + ")";
    }
  }

  String get selectionError {
    if (!isValid &&
        product.size == null &&
        (base.min is SegmentOnSize || base.max is SegmentOnSize))
      return "Select a size";
    return super.selectionError;
  }
}
