import 'package:flutter/material.dart';
import 'package:my_annotations/home_page.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)),
    debugShowCheckedModeBanner: false,
  ));
}
