import { NextFunction, Request, Response } from "express";
import { User } from "./user";
import { Crypt } from "../auth/crypt";
const crypt = new Crypt();
const user = new User();
// const serviceAccount = require("../../credential.json");
// firebase.initializeApp({
//   credential: firebase.credential.cert(serviceAccount),
//   databaseURL: "https://tech-for-cities.firebaseio.com"
// });

export class UserService {
  getUserInfo(req: Request, res: Response, next: NextFunction) {
    try {
      let userId = crypt.getUserIdFromAppKey(req.headers["key"]);
      user.getUser(userId).then((result: any) => {
        if (result) {
          res.json({
            data: result
          });
        } else {
          res.json({
            message: "USER_NOT_FOUND"
          });
        }
      });
    } catch (error) {
      console.log(error);
      res.json({
        message: error
      });
    }
  }
}
