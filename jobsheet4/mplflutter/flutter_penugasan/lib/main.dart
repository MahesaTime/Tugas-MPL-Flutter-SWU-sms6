import 'package:flutter/material.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'First App',
home: Scaffold(
  backgroundColor: Colors.blue,
appBar: AppBar(
title: Text('Flutter 4'),
backgroundColor: Colors.white,
),
body: Center(
child: Text('Penugasan 4 MPL, MiswantoSTI202102207'),
),
),
);
}
}