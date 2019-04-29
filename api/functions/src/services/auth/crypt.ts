import * as crypto from "crypto";
const algorithm = "aes256";
const key = "CITIZEN";
const splitter = "<->";

export class Crypt {
  generateAppKey(userId) {
    return this.encrypt(`CEP<->${userId}<->${new Date().getTime()}`);
  }

  getUserIdFromAppKey(appKey) {
    let dKey = this.decrypt(appKey);
    return dKey.split(splitter)[1];
  }

  getCreatedTimeFromAppKey(appKey) {
    let dKey = this.decrypt(appKey);
    return dKey.split(splitter)[2];
  }

  encrypt(text) {
    var cipher = crypto.createCipher(algorithm, key);
    var encryptedText =
      cipher.update(text, "utf8", "hex") + cipher.final("hex");
    return encryptedText;
  }

  decrypt(encryptedText) {
    var decipher = crypto.createDecipher(algorithm, key);
    var decrypted =
      decipher.update(encryptedText, "hex", "utf8") + decipher.final("utf8");
    return decrypted;
  }

  isTokenValid(appKey) {
    console.log("Validating Token");
    let createdTime: any = this.getCreatedTimeFromAppKey(appKey);
    console.log(createdTime);
    let currentTime: any = new Date().getTime();
    let timeDiff = currentTime - createdTime;
    console.log("Hours diff");
    console.log(new Date(timeDiff).getHours());
    if (new Date(timeDiff).getHours() >= 24) {
      // If time diff is beyond 24 hours, regenerate the token
      return false;
    } else {
      return true;
    }
  }
}
