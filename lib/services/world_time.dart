import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class WorldTime {
  String location; // location name for the UI
  late String time; // the time in that location
  String flag; //url to an asset flag icon
  String url; //location url for api endpoint
  late bool isDaytime;

  WorldTime(this.location, this.flag, this.url);

  Future<void> getTime() async {
    try {
      // make the request.
      Response response =
          await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);
      //print(data);

      //get properties from data
      String datetime = data['datetime'];
      String offset = data['utc_offset'];
      int offset_hour = int.parse(offset.substring(1, 3));
      int offset_minutes = int.parse(offset.substring(4, 6));
      // print(offset);
      // print(offset_minutes);

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: offset_hour, minutes: offset_minutes));
      //set the time property.
      isDaytime = (now.hour >= 6 && now.hour < 20) ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('caught error: $e');
      time = 'Could not get the data';
    }
  }
}
