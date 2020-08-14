import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ombre/MyHomePage.dart';
import 'package:toast/toast.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  File sampleImage;
  String name;
  String language;
  String type;
  String age;
  String url;

  final formKey = new GlobalKey<FormState>();

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("Post Images");
      Toast.show('Please Wait Until Screen pops Out !', context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.white);
      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = imageUrl.toString();
      goToDashPage();
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url) {
    var dbTimeKey = new DateTime.now();
    var formatDay = new DateFormat('EEE');
    var formatTime = new DateFormat('MMM d HH:mm');

    String day = formatDay.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey) + ' - 00:30 GMT+5:30';

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "name": name,
      "day": day,
      "datetime": time,
      "age": age,
      "language": language,
      "type": type
    };

    ref.child("Posts").push().set(data);
  }

  void goToDashPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: sampleImage == null
              ? Text(
                  "select an Image ...",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                )
              : enableUpload(),
        ),
        backgroundColor: Colors.black,
        floatingActionButton: showFab
            ?
            FloatingActionButton.extended(
                heroTag: 'btn1',
                label: Text('add   '),
                backgroundColor: Color(0xFFFF4E78),
                icon: Icon(
                  Icons.add,
                ),
                onPressed: getImage,
              )
            : null,
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Image.file(sampleImage, height: 310.0, width: 660.0),
                    SizedBox(height: 15.0),
                    Text(
                      'DETAILS',
                      style: TextStyle(
                          fontFamily: 'Open',
                          fontSize: 25,
                          color: Colors.white),
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      decoration: new InputDecoration(
                          focusedBorder: InputBorder.none,
                          labelText: 'name',
                          labelStyle: TextStyle(
                              fontSize: 25, color: Color(0xFFFF4E78))),
                      validator: (value) {
                        return value.isEmpty ? 'name is required' : null;
                      },
                      onSaved: (value) {
                        return name = value;
                      },
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      decoration: new InputDecoration(
                          focusedBorder: InputBorder.none,
                          labelText: 'type',
                          labelStyle: TextStyle(
                              fontSize: 25, color: Color(0xFFFF4E78))),
                      validator: (value) {
                        return value.isEmpty ? 'type is required' : null;
                      },
                      onSaved: (value) {
                        return type = value;
                      },
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      decoration: new InputDecoration(
                          focusedBorder: InputBorder.none,
                          labelText: 'language',
                          labelStyle: TextStyle(
                              fontSize: 25, color: Color(0xFFFF4E78))),
                      validator: (value) {
                        return value.isEmpty ? 'language is required' : null;
                      },
                      onSaved: (value) {
                        return language = value;
                      },
                    ),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      decoration: new InputDecoration(
                          focusedBorder: InputBorder.none,
                          labelText: 'age',
                          labelStyle: TextStyle(
                              fontSize: 25, color: Color(0xFFFF4E78))),
                      validator: (value) {
                        return value.isEmpty ? 'age is required' : null;
                      },
                      onSaved: (value) {
                        return age = 'Age ' + value + '+';
                      },
                    ),
                    SizedBox(height: 15.0),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(0, 80, 250, 40),
                    //   child: FloatingActionButton.extended(
                    //     heroTag: 'btn2',
                    //     label: Text('submit'),
                    //     backgroundColor: Color(0xFFFF4E78),
                    //     icon: Icon(
                    //       Icons.send,
                    //     ),
                    //     onPressed: uploadStatusImage,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 250, 40),
                child: FloatingActionButton.extended(
                  heroTag: 'btn2',
                  label: Text('submit'),
                  backgroundColor: Color(0xFFFF4E78),
                  icon: Icon(
                    Icons.send,
                  ),
                  onPressed: uploadStatusImage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
