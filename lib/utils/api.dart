import 'dart:async';
import 'package:http/http.dart' as http;

String baseUrl = "https://us-central1-tech-for-cities.cloudfunctions.net";
String zonerUrl = "/api/position";
 String messageAddedUrl = "/api/chat-message";

class API {
  Future getZone(String lat, String long) {
    return http.post(baseUrl + zonerUrl, body: {"lat": lat, "long": long});
  }

  Future messageAdded(String sender, String message, String group){
     return http.post(baseUrl + messageAddedUrl, body: {"sender": sender, "message": message, "group": group});
   }

  /* Exception Handler */

  showException(Exception e) {
    print(e);
  }
}
