import { NextFunction, Request, Response, Router } from "express";
import { UserService } from "../user/user.service";
import { Crypt } from "./crypt";
import { User } from "../user/user";
const user = new User();
const crypt = new Crypt();
const verificationKeyword = "CEP";
const authExclustions = ["/token"];
export class AuthService {
  public static validateToken() {
    return (req: Request, res: Response, next: NextFunction) => {
      try {
        for (var i = 0; i < authExclustions.length; i++) {
          if (req.url.indexOf(authExclustions[i]) >= 0) {
            next();
            return;
          }
        }
        let headerKey = req.headers["key"];
        if (headerKey) {
          console.log("Header key is - " + headerKey);
          let appKey = crypt.decrypt(headerKey);
          if (
            appKey.indexOf(verificationKeyword) === 0
            // && crypt.isTokenValid(appKey)
          ) {
            next();
          } else {
            res.status(401).send("Not allowed");
          }
        } else {
          res.status(401).send("Not allowed");
        }
      } catch (error) {
        res.json({
          req: req.url,
          message: "Something went wrong in token validation"
        });
      }
    };
  }

  public token(req: Request, res: Response, next: NextFunction) {
    user.verifyAndUpdate(req.params.userId).then((response: any) => {
      res.json(response);
    });
  }

  public verify(req: Request, res: Response, next: NextFunction) {
    let userId = crypt.getUserIdFromAppKey(req.headers["key"]);
    user.verifyAndUpdate(userId).then((response: any) => {
      res.json(response);
    });
  }
}
