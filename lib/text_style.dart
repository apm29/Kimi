import 'package:flutter/material.dart';

final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
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
    baseTextStyle.copyWith(color: Colors.black54, fontSize: 22.0);
