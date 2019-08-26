import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore _firestore;

void main() {
  runApp(new MaterialApp(title: "Dalmia Assistance", home: new DataEntry()));
}

class MyApp extends StatelessWidget {
  final String emailDetails;
  // This widget is the root of your application.
  MyApp({
    Key key,
    @required this.emailDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Dalmia Assistance',
        theme: new ThemeData(
            primarySwatch: Colors.lightBlue,
            primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white))),
        home: new DataEntry(),
        debugShowCheckedModeBanner: false // Default or main screen of the app
        );
  }
}

class DataEntry extends StatefulWidget {
  final String emailDetails;
  DataEntry({
    Key key,
    this.title,
    @required this.emailDetails,
  }) : super(key: key);
  final String title;

  @override
  MyDataEntry createState() => new MyDataEntry();
}

String ceType, loca, am, curr;

class MyDataEntry extends State<DataEntry> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Appbar
      appBar: new AppBar(
        // Title
        title: new Text("Dalmia Assistance"),
      ),
      // Body
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(8.0),
              child: new TextField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: new InputDecoration(
                  hintText: "Type of cement",
                ),
                onChanged: (value) => ceType = value,
                //onSubmitted: (value) => ceType = value,
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(8.0),
              child: new TextField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: new InputDecoration(
                  hintText: "Quantity required",
                ),
                onChanged: (value) => am = value,
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(8.0),
              child: new TextField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: new InputDecoration(
                  hintText: "Kilos, Tonnes etc..,",
                ),
                onChanged: (value) => curr = value,
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(8.0),
              child: new RaisedButton(
                onPressed: dataUpdate,
                child: new Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> dataUpdate() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'test',
      options: const FirebaseOptions(
        googleAppID:
            '161708119594-4srqcjsa9dq21sg0101k66gb2vua8olj.apps.googleusercontent.com',
        gcmSenderID: '161708119594',
        apiKey: 'AIzaSyB4Xe8PghwAaVaTKLT_0Z_b62HQyOLHEF4',
        projectID: 'dalmiacement-deb0e',
      ),
    );

    final _random = new Random();
    int next(int min, int max) => min + _random.nextInt(max - min);

    var orderidNum = next(0,100000);

    _firestore = Firestore(app: app);
    DocumentReference putData =
        _firestore.collection("users").document(widget.emailDetails);
    putData.setData({
      'order_id': orderidNum,
      'cementType': ceType,
      'quant_amt': am,
      'quant_unit': curr
    });

    showToast("Data updated. Your order ID is " + orderidNum.toString(),duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
