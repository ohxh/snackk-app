import 'package:flutter/material.dart';

listFrom<T>(dynamic input) {
  if (input is T) return [input];
  if (input is List<T>) return input;
  throw ErrorDescription("Type is not single element or list");
}
