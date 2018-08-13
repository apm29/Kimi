import 'package:flutter/material.dart';

const baseTextStyle = const TextStyle(fontFamily: 'Poppins');
final headerTextStyle = baseTextStyle.copyWith(
    color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600);
final regularTextStyle = baseTextStyle.copyWith(
    color: const Color(0xffb6b2df), fontSize: 9.0, fontWeight: FontWeight.w400);
final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 12.0);
final commonTextStyle = baseTextStyle.copyWith(
    color: const Color(0xffb6b2df),
    fontSize: 14.0,
    fontWeight: FontWeight.w400);

final headerTitleStyle = baseTextStyle.copyWith(
    color: Colors.black54, fontSize: 20.0, fontWeight: FontWeight.w400);
final hintTextStyle =
    baseTextStyle.copyWith(color: Colors.black54, fontSize: 16.0);
final buttonTextStyle = baseTextStyle.copyWith(color: Colors.black);

final themeStyle1 = baseTextStyle.copyWith(color: Colors.black);
final themeStyle2 = baseTextStyle.copyWith(color: Colors.black87);
final themeStyle3 = baseTextStyle.copyWith(color: Colors.black87);
final themeStyle4 = baseTextStyle.copyWith(color: Colors.green);
final themeBodyStyle1 = baseTextStyle.copyWith(color: Colors.black);
final themeBodyStyle2 = baseTextStyle.copyWith(color: Colors.black87);
final themeTitleStyle1 = baseTextStyle.copyWith(color: Colors.purple);
final themeHeadlineStyle1 = baseTextStyle.copyWith(color: Colors.blue);
final themeSubStyle = baseTextStyle.copyWith(color: Colors.black87);
final themeCaptionStyle = baseTextStyle.copyWith(color: Colors.grey);
final themeButtonStyle = baseTextStyle.copyWith(color: Colors.blueGrey);