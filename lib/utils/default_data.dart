import 'package:hello_chennai/model/apps.dart';
import 'package:hello_chennai/utils/globals.dart';

class DefaultData {
  static String platformTitle = "Citizen Engagement Platform";
  static String platformTagline = "Ithu Namma Chennai";
  static String developedBy = "Tech for Cities";
  static String poweredBy = "Powered by Government of Tamilnadu";
  static String platformLogo = "assets/images/logo/corporationofchennai.png";

  static List<Map<String, dynamic>> apps = [
    {
      "appId": "1",
      "appName": {"en": "Adopt Chennai", "ta": "சென்னை தத்தெடுக்க"},
      "appDesc": {
        "en":
            "Chennai has many waterbodies , park , streets  that requires peoples time and effort to clean and maintain it . The “Adopt Chennai” Micro-app lets you express your interest to adopt/maintain a waterbody, park, street in your locality. The corporation of Chennai requires you to be a part of a registered NGO to adopt/maintain a public property.",
        "ta":
            "சென்னை மக்களின் நேரம் மற்றும் சுத்தம் மற்றும் பராமரிக்க முயற்சியே தேவைப்படும் பல waterbodies, பூங்கா, தெருக்களில் உள்ளது. தத்தெடுக்க சென்னை மைக்ரோ-பயன்பாட்டை நீங்கள் / தத்தெடுக்க உங்கள் பகுதியில் ஒரு waterbody, பூங்கா, தெரு பராமரிக்க உங்கள் ஆர்வத்திற்கு வெளிப்படுத்த உதவுகிறது. சென்னை மாநகராட்சி ஒரு பதிவு அரசு சாரா ஒரு பகுதியாக ஏற்க / ஒரு பொது சொத்து பராமரிக்க இருக்க வேண்டும்."
      },
      "appIconUrl": "assets/images/apps/1.png",
      "appUrl": "https://adopt-nammachennai.firebaseapp.com/",
      "appLaunchDate": "Jan-2019"
    },
    {
      "appId": "2",
      "appName": {"en": "Volunteer Registration", "ta": "தன்னார்வ பதிவு"},
      "appDesc": {
        "en":
            "Volunteering offers vital help to people in need, worthwhile causes, and the community, but the benefits can be even greater for you, the volunteer. Chennai has many volunteer organisations that work for different causes . The “Volunteer for Chennai” Micro-app connects you with NGOs and their activities.",
        "ta":
            "தன்னார்வ தொண்டர் தேவை பயனுள்ளது காரணங்கள், மற்றும் சமூகத்தில் மக்களுக்கு இன்றியமையாத உதவி வழங்குகிறது, ஆனால் அதன் நன்மைகளும், உங்களுக்கு இன்னும் அதிகமாக இருக்க முடியும். சென்னை வெவ்வேறு காரணங்களுக்காக வேலை என்று பல தன்னார்வ நிறுவனங்கள் உள்ளது. மைக்ரோ-பயன்பாட்டின் சென்னை தன்னார்வலர்களாக தொண்டு நிறுவனங்கள் அவற்றின் செயல்பாடுகளை உங்களை இணைக்கிறது."
      },
      "appIconUrl": "assets/images/apps/2.png",
      "appUrl": "https://adopt-nammachennai.firebaseapp.com/page1.html",
      "appLaunchDate": "Jan-2019"
    },
    {
      "appId": "3",
      "appName": {"en": "Citizen Events", "ta": "சிட்டிசன் நிகழ்வுகள்"},
      "appDesc": {
        "en":
            "The Chennai corporation and associated NGO’s conduct many public welfare events that require your time. The “Upcoming Events” micro-app lets you coordinate with the event organisers and helps you participate in events that impact the life of people.",
        "ta":
            "சென்னை மாநகராட்சி மற்றும் தொடர்புடைய NGO க்களின் நடத்தை பல பொது நல உங்கள் நேரம் தேவைப்படும் நிகழ்வுகள். எதிர்வரும் நிகழ்வுகள் மைக்ரோ-பயன்பாட்டை நீங்கள் நிகழ்வு அமைப்பாளர்கள் ஒத்துழைப்பு அனுமதித்து, மக்களின் வாழ்க்கை பாதிக்கும் நிகழ்வுகள் பங்கேற்க உதவுகிறது."
      },
      "appIconUrl": "assets/images/apps/3.png",
      "appUrl": "https://adopt-nammachennai.firebaseapp.com/page2.html",
      "appLaunchDate": "Jan-2019"
    },
    {
      "appId": "4",
      "appName": {"en": "Grievances", "ta": "மனக்குறைகளின்"},
      "appDesc": {
        "en":
            "The Grievances micro-app lets you register complaints with the Chennai city corporation. You can view and follow up with the status of your application at any given point of time.",
        "ta":
            "மனக்குறைகளின் மைக்ரோ பயன்பாட்டை நீங்கள் சென்னை நகரம் மற்றும் பெருநிறுவனம் புகார்கள் பதிவு உதவுகிறது. நீங்கள் பார்க்க மற்றும் நேரம் எந்தக் கட்டத்திலும் உங்கள் விண்ணப்பத்தின் நிலை பின்தொடர முடியும்."
      },
      "appIconUrl": "assets/images/apps/4.png",
      "appUrl": "https://adopt-nammachennai.firebaseapp.com/page3.html",
      "appLaunchDate": "Jan-2019"
    },
    {
      "appId": "5",
      "appName": {"en": "News", "ta": "செய்திகள்"},
      "appDesc": {
        "en":
            "Top headlines at fingertips. It contains news from The Hindu and Times of India",
        "ta": "செய்தி இதழ்களில் இடம் பெறும் செய்திகள் அனைத்தையும் படித்துவிட"
      },
      "appIconUrl": "assets/images/apps/6.png",
      "appUrl": "https://chennai-news.herokuapp.com/",
      "appLaunchDate": "Added on Mar-2019"
    }
  ];

  DefaultData() {
    print("Executing");
    apps.forEach((app) {
      print(app["appName"]);
      Map<String, Object> map1 = app["appName"];
      Map<String, Object> map2 = app["appDesc"];
      fireCollections
          .createApp(new Apps(app["appId"], map1, map2, app["appIconUrl"],
              app["appUrl"], app["appLaunchDate"]))
          .then((val) {
        print(val);
      });
    });
  }
}
