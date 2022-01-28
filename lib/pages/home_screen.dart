import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var idController = new TextEditingController();
  var descController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _readDescription();
    _readID();
  }

  _readDescription() async {
    final prefs = await SharedPreferences.getInstance();

    final key2 = 'description';
    final value2 = prefs.getString(key2) ?? "";
    descController.text = value2;
  }

  _readID() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'userid';
    final value = prefs.getString(key) ?? "";
    idController.text = value;
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'userid';
    final value = idController.text;
    final key2 = 'description';
    final value2 = descController.text;

    prefs.setString(key, value);
    prefs.setString(key2, value2);
    print('saved to key : $key value: $value');
    print('saved to key : $key2 value: $value2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Location Sender"),
        actions: <Widget>[
          Padding(
            child: Icon(Icons.search),
            padding: const EdgeInsets.only(right: 10.0),
          )
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new TextField(
              decoration: InputDecoration(hintText: "ID"),
              controller: idController,
            ),
          ),
          new ListTile(
            title: new TextField(
              decoration: InputDecoration(hintText: "Description"),
              controller: descController,
            ),
          ),
          new ListTile(
            title: new RaisedButton(
              padding: EdgeInsets.all(25),
              textTheme: ButtonTextTheme.primary,
              color: Colors.amber,
              child: new Text("NEXT"),
              onPressed: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => SendingInfo(
                    id: idController.text,
                    desc: descController.text,
                  ),
                );
                _save();
                Navigator.of(context).push(route);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SendingInfo extends StatefulWidget {
  final String id;
  final String desc;
  SendingInfo({Key key, this.id, this.desc}) : super(key: key);
  @override
  _SendingInfoState createState() => _SendingInfoState();
}

class _SendingInfoState extends State<SendingInfo> {
  String id;
  String description;
  double longitude;
  double latitude;
  Geolocator _geolocator;
  Position _position;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    description = widget.desc;

    _geolocator = Geolocator();
    updateLocation();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
    StreamSubscription positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      _position = position;
    });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      longitude = _position.longitude;
      latitude = _position.latitude;
      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  Future sendRequest(String id, String desc, double lat, double lon) async {
    print("id: " +
        id +
        "  Desc: " +
        desc +
        "  lat:  " +
        lat.toString() +
        "  lon: " +
        lon.toString());
    String url = "http://developer.kensnz.com/api/addlocdata?userid=" +
        id +
        "&latitude=" +
        lat.toString() +
        "&longitude=" +
        lon.toString() +
        "&description=" +
        desc;

    final response = await http.get(url);
    print(url);
    print((response.body));
    if (response.statusCode == 200) {
      return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Succesfully loaded"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text('Ok'))
            ],
          ));
    } else {
      return showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Something went wrong"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text('Ok'))
            ],
          ));
    }
  }

  void getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      longitude = position.longitude;
      latitude = position.latitude;
    });
    print("latitude :" + latitude.toString());
    print("longitude :" + longitude.toString());
  }

  // Future<Map<String, dynamic>> sendRequestWithPost(
  //     String id, String desc, double lat, double lon) async {
  //   var client = http.Client();
  //   Map<String, dynamic> requestBody = {
  //     "userid": id,
  //     "latitude": lat,
  //     "longitude": lon,
  //     "description": desc
  //   };
  //   print("id: " +
  //       id +
  //       "  Desc: " +
  //       desc +
  //       "  lat:  " +
  //       lat.toString() +
  //       "  lon: " +
  //       lon.toString());
  //   String url = "http://developer.kensnz.com/api/addlocdata";

  //   final response = await client.post(
  //     Uri.encodeFull(url),
  //     body: """
  //     {
  //      "userid": $id,
  //     "latitude": $lat,
  //     "longitude": $lon,
  //     "description": $desc

  //     }

  //      """,
  //   ).whenComplete(client.close);

  //   if (!mounted) {
  //     return {'success': false};
  //   }
  //   setState(() {
  //     var res = json.decode(response.body);
  //     print(res);
  //   });
  //   return json.decode(response.body);
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Location Sender"),
        actions: <Widget>[
          Padding(
            child: Icon(Icons.search),
            padding: const EdgeInsets.only(right: 10.0),
          )
        ],
      ),
      body: new Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "ID: ${widget.id}",
                style: Theme.of(context).textTheme.title,
              ),
              new Text(
                "DESCRIPTION: ${widget.desc}",
                style: Theme.of(context).textTheme.title,
              ),
              new Text(
                "LATITUDE: ${latitude != null ? latitude.toString() : '0'}",
                style: Theme.of(context).textTheme.title,
              ),
              new Text(
                "LONGITUDE: ${longitude != null ? longitude.toString() : '0'}",
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 150,
              ),
              new ListTile(
                title: new RaisedButton(
                  padding: EdgeInsets.all(25),
                  textTheme: ButtonTextTheme.primary,
                  color: Colors.amber,
                  child: new Text("GET LOCATION AGAIN"),
                  onPressed: () {
                    getLocation();
                  },
                ),
              ),
              new ListTile(
                title: new RaisedButton(
                  padding: EdgeInsets.all(25),
                  textTheme: ButtonTextTheme.primary,
                  color: Colors.amber,
                  child: new Text("POST LOCATION"),
                  onPressed: () {
                    sendRequest(id, description, latitude, longitude);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      //  new Text("${widget.id}"),
      // new Text("${widget.desc}"),
    );
  }
}
