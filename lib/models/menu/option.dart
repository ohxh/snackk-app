import 'may_segment_on_size.dart';

class Option {
  String name;
  MaySegmentOnSize<int> price;

  Option.fromJSON(dynamic k, dynamic v) {
    name = k;
    price = MaySegmentOnSize.fromJSON(v);
  }

  @override
  String toString() => name;
}