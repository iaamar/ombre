import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Posts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String dropdownValue = 'Recommended';
  List<Map<dynamic, dynamic>> postList = [];
  final posts = FirebaseDatabase.instance.reference().child("Posts");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFF090d0d),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 12, 13, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Hello ,',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Open',
                                    color: Colors.white),
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Amar!',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Open',
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: ExactAssetImage('assets/amar.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Text(
                    'Events curated just for you ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open',
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Color(0xFF090d0d),
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      style: TextStyle(color: Colors.white),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['Recommended', 'Upcomming', 'Popularity']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: FutureBuilder(
                    future: posts.once(),
                    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        postList.clear();
                        Map<dynamic, dynamic> values = snapshot.data.value;
                        values.forEach((key, values) {
                          postList.add(values);
                        });
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: postList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: Color(0xFF090d0d),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            postList[index]["name"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontFamily: 'Open',
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 259,
                                        width: 250,
                                        child: Image.network(
                                          postList[index]["image"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            postList[index]["type"] + " | ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'Open',
                                            ),
                                          ),
                                          Text(
                                            postList[index]["language"] + " | ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'Open',
                                            ),
                                          ),
                                          Text(
                                            postList[index]["age"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'Open',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            postList[index]["day"] + " | ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'Open',
                                            ),
                                          ),
                                          Text(
                                            postList[index]["datetime"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'Open',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
              )
            ],
          ),),
    );
  }
}
