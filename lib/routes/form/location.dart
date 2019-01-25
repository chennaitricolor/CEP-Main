import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as gps;
import "package:google_maps_webservice/places.dart";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;

  LatLng _center = LatLng(13.1223434, 80.2859642);

  var currentLocation = <String, double>{};

  var location = new gps.Location();
  final places = new GoogleMapsPlaces(apiKey: "AIzaSyDfN9GP16uMtGrotUOkV9oKAT3o2OntvU0");

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTypeButtonPressed() async {
    try {
      print("======");
      currentLocation = await location.getLocation();
      print(currentLocation);
    } on Exception {
      currentLocation = null;
    }
    

    setState(() {
      _center = new LatLng(currentLocation['latitude'], currentLocation['longitude']);
    });
    locate();
  }

  void _locateLandmark(String landmark) async {
    print(landmark);
    PlacesSearchResponse area = await places.searchByText(landmark);
    print(area.results[0].geometry.location.lat);
    setState(() {
      _center =
          new LatLng(area.results[0].geometry.location.lat, area.results[0].geometry.location.lng);
    });
    locate();
  }

  void locate() {
    mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(zoom: 17.0, target: _center)));
    mapController.clearMarkers();
    mapController.addMarker(
      MarkerOptions(
        position: _center,
        icon: BitmapDescriptor.defaultMarkerWithHue(10),
        draggable: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 12.0,
              ),
              onMapCreated: _onMapCreated,
              //  options: GoogleMapOptions(
              //    trackCameraPosition: true,
              //    cameraPosition: CameraPosition(
              //      target: _center,
              //      zoom: 11.0,
              //    ),
              //  ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: TextField(
                onSubmitted: (val) {
                  _locateLandmark(val);
                },
                decoration: new InputDecoration(
                    labelText: 'Landmark', hintText: 'eg. chromepet'),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 70, right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.gps_fixed, size: 26.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
