import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:algorithm_send_location/pages/home_screen.dart';
import 'package:algorithm_send_location/pages/splash_screen.dart';
import 'package:algorithm_send_location/pages/initial_warning.dart';
import 'package:geolocator/geolocator.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(),
};

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> _checkConnectivity;

  @override
  void initState() {
    _checkConnectivity = _onCheckConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Map Locator',
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    return FutureBuilder<bool>(
      future: _checkConnectivity,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final hasConnection = snapshot.data;

            return hasConnection ? SplashScreen() : WarningScreen();

          default: // Return a loading indicator while checking connection
            return Scaffold(
              body: Center(
                child: SizedBox(
                  width: 56.0,
                  height: 56.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
        }
      },
    );
  }

  Future<bool> _onCheckConnectivity() async {
    var internetResult = await Connectivity().checkConnectivity();
    bool locationResult = await Geolocator().isLocationServiceEnabled();
    if (internetResult == ConnectivityResult.none || !locationResult) {
      //accessible = false;
      //print(accessible);
      return false;
    } else {
      //accessible = true;
      //print(accessible);
      return true;
    }
  }
}

// get _checkConnectivity async {
//   var internetResult = await Connectivity().checkConnectivity();
//   bool locationResult = await Geolocator().isLocationServiceEnabled();
//   if (internetResult == ConnectivityResult.none || !locationResult) {
//     //accessible = false;
//     //print(accessible);
//     return false;
//   } else {
//     //accessible = true;
//     //print(accessible);
//     return true;
//   }
// }

// void main() => runApp(new MaterialApp(
//     theme:
//         ThemeData(primaryColor: Colors.amber, accentColor: Colors.green[200]),
//     debugShowCheckedModeBanner: false,
//     home: false ? SplashScreen() : WarningScreen(),
//     routes: routes));

// get _checkConnectivity async {
//   var internetResult = await Connectivity().checkConnectivity();
//   bool locationResult = await Geolocator().isLocationServiceEnabled();
//   if (internetResult == ConnectivityResult.none || !locationResult) {
//     return false;
//   } else {
//     return true;
//     //return true;
//   }
// }
