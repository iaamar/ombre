import 'package:flutter/material.dart';

class Show extends StatelessWidget {
  const Show({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('This is Show page', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
