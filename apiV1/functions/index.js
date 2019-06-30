const functions = require('firebase-functions');
const geo = require('./geojson');
const express = require('express');
const cors = require('cors');
const inside = require('point-in-geopolygon');
const app = express();

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// Automatically allow cross-origin requests
app.use(cors({ origin: true }));

app.get('/', (req, res) => {
    res.end("Hey! Welcome to Tech for Cities!");
});

app.post('/position', (req, res) => {
    let position = req.body;
    var geojson = geo.zones;
    console.log("Searching for : Lat - " + position.lat + " Long - " + position.long);
    let result = {}
    try {
        for (var i in geojson.features) {
            var x1 = geojson.features[i]
            if (inside.polygon(x1.geometry.coordinates, [position.long, position.lat])) {
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
        console.log(err)
    }
    console.log("Found result : " + JSON.stringify(result));
    res.json(Object.assign({}, { data: result }))
});


 app.post('/chat-message',(req,res) => {
     var {sender, message, group} = req.body;
     const topicPayload = {
            notification: {
                 title: group,
                 body: `${sender} : ${message}`
                 }
         };
     admin.messaging().sendToTopic("chat-chennai",topicPayload)
         .catch((error) => {
                 console.log('Notification sent failed:',error);
         });
     res.json(`${sender} sent :  ${message} in ${group}`)
 });
// Expose Express API as a single Cloud Function:
exports.api = functions.https.onRequest(app);
