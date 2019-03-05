import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TimelinePage())
);

class HistoryEntry {
  int eventId;
  String name;
  String description;
  String year;
  String eventType;
  String imgPath;
  String link;

  HistoryEntry({ this.eventId, this.name, this.description, this.year, this.eventType, this.imgPath, this.link });

  factory HistoryEntry.toJson(dynamic entry) {
    return HistoryEntry(
      eventId: entry['id'],
      name: entry['name'],
      description: entry['description'],
      year: entry['year'],
      eventType: entry['eventType'],
      imgPath: entry['imgPath'],
      link: entry['link']
    );
  }
}

class TimelinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimelinePageState();
  }
}

class TimelinePageState extends State<TimelinePage> {
  
  List<HistoryEntry> historyEntries;
  TextStyle labelStyle = TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 10);
  TextStyle labelStyleBold = TextStyle(fontWeight:FontWeight.bold, color: Colors.black.withOpacity(0.5), fontSize: 10);
  Color lightGrey = Colors.grey[300];
  Color presidencyColor = Colors.lightBlue;

  Future loadHistoryEntries() async {
    String jsonString = await rootBundle.loadString('assets/events.json');
    setState(() {
      var data = json.decode(jsonString);
      historyEntries = List<HistoryEntry>();
      for(var entry in data) {
        historyEntries.add(HistoryEntry.toJson(entry));
      }
    });
  }

  void initState() {
    super.initState();
    loadHistoryEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: lightGrey,
        child: historyEntries != null ? ListView.builder(
          itemCount: historyEntries.length,
          itemBuilder: (context, index) {

            var entry = historyEntries[index];

            return Padding(
              padding: EdgeInsets.only(left: 20),
              child: Stack(
                children: <Widget>[
                  Container(
                    margin:EdgeInsets.only(left: 6),
                    color: Colors.grey,
                    width: 2,
                    height: 165
                  ),
                  Positioned(
                    top: 65,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin:EdgeInsets.only(top: 6, left: 3),
                          color: entry.eventType == 'presidency' ? presidencyColor : Colors.grey,
                          height: 2,
                          width: entry.eventType == 'presidency' ? 210 : 110,
                        ),
                        ClipOval(
                          child: Container(
                            color: entry.eventType == 'presidency' ? presidencyColor : Colors.grey,
                            width: 15,
                            height: 15,
                          )
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: entry.eventType == 'presidency' ? 180 : 80,
                    top: 30,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ClipOval(
                              child: Container(
                                width: 80,
                                height: 80,
                                color: entry.eventType == 'presidency' ? presidencyColor : Colors.grey
                              )
                            ),
                            Positioned(
                              top: 5,
                              left: 5,
                              child: ClipOval(
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  child: Image.asset('assets/' + entry.imgPath + '.jpg', fit:BoxFit.cover, width: 80,),
                                )
                              ),
                            )
                          ],
                        ),
                        Container(
                          width: 130,
                          margin:EdgeInsets.only(top: 5),
                          child: Column(
                            children: <Widget>[
                              Text(DateFormat.yMMMd('en_US').format(DateTime.parse(entry.year)), style: labelStyle, textAlign: TextAlign.center),
                              Text(entry.name, style: labelStyleBold, textAlign: TextAlign.center),
                              Text(entry.description, style: labelStyle, textAlign: TextAlign.center),
                            ],
                          )
                        )
                      ],
                    )
                  )
                ],
              ),
            );
          },
        ) : Center(child: CircularProgressIndicator()),  
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}