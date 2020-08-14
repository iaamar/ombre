import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'Add.dart';
import 'Dashboard.dart';
import 'Show.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final tabs = [Dashboard(), Add(), Show()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        color: Color(0xFF263240),
        buttonBackgroundColor: Color(0xFFFF4E78),
        backgroundColor: Colors.black54,
        height: 60,
        items: <Widget>[
          Icon(
            Icons.dashboard,
            size: 35,
            color: Colors.white,
          ),
          Icon(Icons.add, size: 35, color: Colors.white),
          Icon(Icons.event_seat, size: 35, color: Colors.white),
        ],
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
      ),
    );
  }
}
