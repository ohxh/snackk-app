import 'dart:collection';

abstract class MaySegmentOnSize<T> {
  factory MaySegmentOnSize.fromJSON(dynamic d) {
    if (d is Map) return SegmentOnSize(LinkedHashMap.from(d.cast<String, T>()));
    if (d is int) return SingleValue(d as T);
    return null;
  }

  T evaluate(String size);
}

class SegmentOnSize<T> implements MaySegmentOnSize<T> {
  LinkedHashMap<String, T> sizes;
  SegmentOnSize(this.sizes);
  
  T evaluate(String size) => sizes[size];

  @override
  String toString() => "Segmented: " + sizes.toString();
}

class SingleValue<T> implements MaySegmentOnSize<T> {
  T value;
  SingleValue(this.value);

  T evaluate(String size) => value;

  @override
  String toString() =>  value.toString();
}