import 'package:flutter/material.dart';
import 'package:funcards/screens/home.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF3EBACE),
        accentColor: Color(0xFFD8ECF1),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ));
