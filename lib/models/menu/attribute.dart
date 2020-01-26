import 'may_segment_on_size.dart';
import 'option.dart';

class Attribute {
  String name;
  List<Option> options;
  MaySegmentOnSize<int> min, max;
  List<Option> defaults = new List();

  Attribute();

  Attribute.fromJSON(dynamic json) :
    name = json['name'],
    min =  MaySegmentOnSize.fromJSON(json['min']) ?? SingleValue(0),
    max = MaySegmentOnSize.fromJSON(json['max']) ?? SingleValue(0),
    options = List() 
    {json['options'].forEach((k,v) => options.add(Option.fromJSON(k,v)));}

  Attribute copyWithDefaults(List<Option> defaults) {
    Attribute attribute = Attribute();
    attribute.name = this.name;
    attribute.options = this.options;
    attribute.min = this.min;
    attribute.max = this.max;
    attribute.defaults = defaults;
    return attribute;
  }

  factory Attribute.fromJSONReference(dynamic json, List<Attribute> allAttributes) {
      if(json.runtimeType == String) { 
        // Cases like "- Color"
        // No defaults are given for the drink, so use the option-level defaults
        return allAttributes.firstWhere(((test) => test.name == json));
      }
      else if(json is Map) { 
        String name = json.keys.first;
        String defaultJSON = json[name];
        List<Option> defaults = new List();

        Attribute atr = allAttributes.firstWhere(((x) => x.name == name));

        if(defaultJSON is String) { //vCases like "- Color: Red"
          defaults.addAll(atr.options.where((option) => option.name == defaultJSON).toList());
        }
        if(defaultJSON.runtimeType == List) {
          defaults.addAll(atr.options.where((option) => defaultJSON.contains(option.name)).toList());
        }
      return atr.copyWithDefaults(defaults);
    }
    else return null;
  }

  

  @override
  String toString() => name;
}