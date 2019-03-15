import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false,home: TimelinePage()));
class HistoryEntry {
  int eventId; String name; String description; String year; String eventType; String imgPath; String link;
  HistoryEntry({ this.eventId, this.name, this.description, this.year, this.eventType, this.imgPath, this.link });
  factory HistoryEntry.toJson(dynamic entry) { return HistoryEntry(eventId: entry['id'],name: entry['name'],description: entry['description'],year: entry['year'],eventType: entry['eventType'],imgPath: entry['imgPath'],link: entry['link']);}
}
class TimelinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() { return TimelinePageState(); }
}
class TimelinePageState extends State<TimelinePage> {
  List<HistoryEntry> historyEntries; String dateString = ''; double itemSize = 180; int rowOffset = 3; ScrollController _scrollController =ScrollController();TextStyle labelStyle = TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 10);
  TextStyle labelStyleBold = TextStyle(fontWeight:FontWeight.bold, color: Colors.black.withOpacity(0.5), fontSize: 10);
  Color lightGrey = Colors.grey[300]; Color presidencyColor = Colors.lightBlue; Color eventColor = Colors.redAccent;
  Future loadHistoryEntries() async { String jsonString = await rootBundle.loadString('assets/events.json'); setState(() { historyEntries = List<HistoryEntry>(); json.decode(jsonString).forEach((e) { historyEntries.add(HistoryEntry.toJson(e)); }); });}
  BoxDecoration circleDecoration(Color color) { return BoxDecoration(shape: BoxShape.circle, color: color); }
  void initState() { super.initState(); Future.delayed(Duration(milliseconds: 2000), () { loadHistoryEntries(); });}
  String getFormattedDate(int index) { return index == historyEntries.length - 1 ? DateFormat.y('en_US').format(DateTime.parse(historyEntries[index].year)) : DateFormat.yMMMd('en_US').format(DateTime.parse(historyEntries[index].year)); }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: historyEntries != null ? Stack(children: <Widget>[
          Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[ Opacity(opacity: 0.1,child: Image.asset('assets/us_map.png', width: 200, height: 150)),Text(dateString, style:TextStyle(fontFamily: 'TraditioAh', color: Colors.grey.withOpacity(0.5), fontSize: 70))])),
          Container(margin: EdgeInsets.only(left: 37),color: Colors.grey.withOpacity(0.5),width: 1),Container(child: NotificationListener(child: ListView.builder(controller: _scrollController, itemExtent: 180,
              itemCount: historyEntries.length, itemBuilder: (context, index) { return Container(height: 180,padding: EdgeInsets.only(left: 30),child: Stack( children: <Widget>[
                      Stack(children: <Widget>[Container(margin: index == 0 ? EdgeInsets.only(top: 0) : EdgeInsets.only(top: 150),child: Container(width: 15,height: 15,decoration: this.circleDecoration((index == 0 || index == historyEntries.length - 1) ? Colors.lightGreen : Colors.transparent)))],),
                      Positioned(top: 65,child: Stack(children: <Widget>[Container(margin:EdgeInsets.only(top: 6, left: 3),color: historyEntries[index].eventType == 'presidency' ? presidencyColor : eventColor, height: 2, width: historyEntries[index].eventType == 'presidency' ? 210 : 110), Container(width: 15,height: 15,decoration: this.circleDecoration(historyEntries[index].eventType == 'presidency' ? presidencyColor : eventColor))])), Positioned(left: historyEntries[index].eventType == 'presidency' ? 180 : 80, top: 30, child: Column(children: <Widget>[ GestureDetector(onTap: () async { await launch(historyEntries[index].link); }, child: Stack(children: <Widget>[Container(width: 85, height: 85, decoration: this.circleDecoration(historyEntries[index].eventType == 'presidency' ? presidencyColor : eventColor)), Positioned(top: 2.5, left: 2.5, child: ClipOval(child: Container(width: 80,height: 80,child: Image.asset('assets/' + historyEntries[index].imgPath + '.jpg', fit:BoxFit.cover, width: 70, height: 70))))])),Container(width: 130,margin:EdgeInsets.only(top: 5),child: Column( children: <Widget>[Text(getFormattedDate(index), style: labelStyleBold, textAlign: TextAlign.center),Text(historyEntries[index].name + '\n' + historyEntries[index].description, style: labelStyle, textAlign: TextAlign.center)],))]))],
                  ));}), onNotification: (t) { setState(() { dateString = DateFormat.y('en_US').format(DateTime.parse(historyEntries[(_scrollController.offset ~/ itemSize).toInt() + rowOffset].year)); });}))]) : Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Opacity(child: Image.asset('assets/history_logo.png', width: 200, height: 200), opacity: 0.5),CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.grey))])));
  }
}