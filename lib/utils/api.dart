import 'dart:async';
import 'package:http/http.dart' as http;

String baseUrl = "https://us-central1-tech-for-cities.cloudfunctions.net";
String zonerUrl = "/findZone/position";

class API {
  Future getZone(String lat, String long) {
    return http.post(baseUrl + zonerUrl, body: {"lat": lat, "long": long});
  }

  /* Exception Handler */

  showException(Exception e) {
    print(e);
  }
}
