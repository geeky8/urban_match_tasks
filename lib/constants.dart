import 'package:flutter/material.dart';

TextStyle customTextStyle(
    {required double fontSize, required FontWeight weight, bool? isHeader}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: weight,
    color: (isHeader != null) ? Colors.white : Colors.black,
  );
}
