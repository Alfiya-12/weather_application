import 'package:flutter/material.dart';
import 'package:weather_application/screens/SplashScreen.dart';
import 'package:weather_application/screens/homeScreen.dart';

void main(){
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: splashScreen(),
  ));
}