import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/constants/colors.dart';

const searchBoxDecoration = InputDecoration(
//  hintText: 'Enter your mobile number',
    hintStyle: TextStyle(
        fontFamily: 'Open', fontWeight: FontWeight.w600, color: hintTextColor),
    fillColor: Colors.white,
    filled: true,
    counterText: "",
    focusColor: Colors.black,
    contentPadding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: searchBoxBorder, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(29.0)),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(29)),
        borderSide: BorderSide(color: searchBoxBorder, width: 1)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(29)),
        borderSide: BorderSide(color: searchBoxBorder, width: 1)));
