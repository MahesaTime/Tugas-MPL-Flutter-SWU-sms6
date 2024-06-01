import 'package:flutter/material.dart';

class StateTeksUtama extends State<TeksUtama> {
  var listNama = [
    'Miswanto',
    'Alief Wahyulianto',
    'Gias Garda Pamungkas',
    'Asep Dwi Saputra',
    'Rizqi Mohammad Saputra',
  ];
  var listWarna = [
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.lime,
    Colors.indigo,
    Colors.deepPurple,
    Colors.cyan,
    Colors.blue,
    Colors.yellow
  ];
  int index = 0;

  void incrementIndex() {
    setState(() {
      index++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Apa kabar",
          textDirection: TextDirection.ltr,
        ),
        Text(
          listNama[index % listNama.length],
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: listWarna[index % listWarna.length],
          ),
        ),
      ],
    );
  }
}

class TeksUtama extends StatefulWidget {
  final StateTeksUtama state = StateTeksUtama();

  @override
  StateTeksUtama createState() => state;
}

void main() => runApp(MyApp());

TeksUtama teksUtama = TeksUtama();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First App StatefulWidget',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 16.0), // Tambahkan padding di atas
            child: teksUtama,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Refresh',
          child: Icon(Icons.refresh),
          onPressed: teksUtama.state.incrementIndex,
        ),
      ),
    );
  }
}