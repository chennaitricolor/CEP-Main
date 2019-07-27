const functions = require("firebase-functions");
const geo = require("./geojson");
const express = require("express");
const cors = require("cors");
const inside = require("point-in-geopolygon");
const user = require("./user/user");
const app = express();
const path = require('path');

const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

// Automatically allow cross-origin requests
app.use(cors({ origin: true }));

app.use(function(req, res, next) {

    // Website you wish to allow to connect
    res.setHeader('Access-Control-Allow-Origin', '*');
    // res.setHeader('Access-Control-Allow-Origin', 'http://localhost:3000');

    // Request methods you wish to allow
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');

    // Request headers you wish to allow
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,Authorization,content-type,__setXHR_');

    // Set to true if you need the website to include cookies in the requests sent
    // to the API (e.g. in case you use sessions)
    res.setHeader('Access-Control-Allow-Credentials', true);

    // Pass to next layer of middleware
    next();
});

app.use('/', express.static(path.join(__dirname, "/static")));

app.get("/", (req, res) => {
  res.end("Hey! Welcome to Tech for Cities!");
});


app.post("/position", (req, res) => {
  let position = req.body;
  var geojson = geo.zones;
  console.log(
    "Searching for : Lat - " + position.lat + " Long - " + position.long
  );
  let result = {};
  try {
    for (var i in geojson.features) {
      var x1 = geojson.features[i];
      if (
        inside.polygon(x1.geometry.coordinates, [position.long, position.lat])
      ) {
        var foundResult = x1.properties.name;
        if (foundResult.indexOf("Ward") >= 0) {
          result.wardNo = foundResult.split("Ward")[1].trim();
        }
        if (foundResult.indexOf("Zone") >= 0) {
          result.zoneInfo = foundResult;
        }
      } else {
        // console.log("")
      }
    }
  } catch (err) {
    console.log(err);
  }
  console.log("Found result : " + JSON.stringify(result));
  res.json(Object.assign({}, { data: result }));
});

app.post("/user/:token", (req, res) => {
  user.getUserInfoByUserId(req.params.token).then(response => {
    if (response) {
      res.status(200).json({ data : response });
    } else {
      res.status(404).send('Not found');
    }
  });
});

app.post("/validate/:mobileNo", (req, res) => {
  user.getUserByNumber(req.params.mobileNo).then(response => {
      res.status(200).json({ data : response });
  });
});

app.post("/chat-message", (req, res) => {
  var { sender, message, group } = req.body;
  const topicPayload = {
    notification: {
      title: group,
      tag: group,
      body: `${sender} : ${message}`
    }
  };
  admin
    .messaging()
    .sendToTopic(group, topicPayload)
    .catch(error => {
      console.log("Notification sent failed:", error);
    });
  res.json(`${sender} sent :  ${message} in ${group}`);
});
// Expose Express API as a single Cloud Function:
exports.api = functions.https.onRequest(app);
