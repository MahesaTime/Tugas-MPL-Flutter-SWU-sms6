import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: KalenderHomePage(),
    );
  }
}

class KalenderHomePage extends StatefulWidget {
  @override
  _KalenderHomePageState createState() => _KalenderHomePageState();
}

class _KalenderHomePageState extends State<KalenderHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Map<String, String>>> _events = {};
  String _weatherInfo = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  String _formatDay(DateTime date) {
    List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    return days[date.weekday - 1];
  }

  void _addEvent(String event, String details) {
    if (_selectedDay != null) {
      final eventText = '${_formatDay(_selectedDay!)} ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}: $event';
      if (_events[_selectedDay!] == null) {
        _events[_selectedDay!] = [];
      }
      setState(() {
        _events[_selectedDay!]!.add({'event': eventText, 'details': details});
      });
    }
  }

  Future<void> _fetchWeather() async {
    final apiKey = 'YOUR_API_KEY'; // Ganti dengan API Key OpenWeatherMap
    final city = 'Jakarta'; // Ganti dengan nama kota yang diinginkan
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temperature = data['main']['temp'];
        final description = data['weather'][0]['description'];
        setState(() {
          _weatherInfo = '$temperature°C, $description';
        });
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      setState(() {
        _weatherInfo = 'Failed to get weather';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController eventController = TextEditingController();
    TextEditingController detailsController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Kalender App'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                _weatherInfo,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tanggal yang dipilih: ${_formatDay(_selectedDay!)} ${_selectedDay!.day} / ${_selectedDay!.month} / ${_selectedDay!.year}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                const daysOfWeek = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                final text = daysOfWeek[day.weekday - 1];
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(color: day.weekday == DateTime.sunday ? Colors.red : null),
                  ),
                );
              },
              defaultBuilder: (context, day, focusedDay) {
                if (day.weekday == DateTime.sunday) {
                  return Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return null;
              },
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.black),
              weekendStyle: TextStyle(color: Colors.red),
            ),
          ),
          if (_selectedDay != null && _events[_selectedDay!] != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jadwal Kepentingan:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ..._events[_selectedDay!]!.map((event) => ListTile(
                        title: Text(event['event']!),
                        subtitle: Text(event['details']!),
                      )),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: eventController,
                  decoration: InputDecoration(
                    labelText: 'Nama Jadwal Kepentingan',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(
                    labelText: 'Rincian Jadwal Kepentingan',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _addEvent(eventController.text, detailsController.text);
                    eventController.clear();
                    detailsController.clear();
                  },
                  child: Text('Tambah Jadwal Kepentingan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
