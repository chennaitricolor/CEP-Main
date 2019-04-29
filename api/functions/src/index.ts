import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as firebaseHelper from "firebase-functions-helper";
import * as express from "express";
import * as bodyParser from "body-parser";
import { LocationService } from "./services/location/location.service";
import { NextFunction, Request, Response, Router } from "express";
import * as device from "express-device";
import { AuthService } from "./services/auth/auth.service";
import * as crypto from "crypto";
import { UserService } from "./services/user/user.service";
const locationService = new LocationService();
const userService = new UserService();
const authService = new AuthService();

admin.initializeApp(functions.config().firebase);
const db = admin.firestore();
const app = express();
const main = express();
const ngoCollection = "ngo";

main.use("/api", AuthService.validateToken(), app);
main.use(bodyParser.json());
main.use(bodyParser.urlencoded({ extended: false }));
// nammaChennai is your functions name, and you will pass main as
// a parameter
export const nammaChennai = functions.https.onRequest(main);

app.use(device.capture());
app.get("/platform", (req: Request, res: Response, next: NextFunction) => {
  res.send(
    `Welcome to Citized Engagement Platform API v1 ${req[
      "device"
    ].type.toUpperCase()}`
  );
});

// Auth
app.post("/token/:userId", authService.token);
app.post("/verify", authService.verify);

// User
app.get("/user", userService.getUserInfo);

// Find Ward
app.post("/findWard", locationService.findWard);
