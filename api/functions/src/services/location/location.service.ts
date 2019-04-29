import { NextFunction, Request, Response } from 'express';
import { Location } from './location.model';
import { default as geodata } from './geojson';
import * as inside from 'point-in-geopolygon';

export class LocationService {

    public findWard(req: Request, res: Response, next: NextFunction) {
        let position: Location = req.body;
        var geojson = geodata;
        console.log("Searching for : Lat - " + position.lat + " Long - " + position.long);
        let result: any = {}    
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
                    //console.log(false)
                }
            }
        } catch (err) { }
        console.log("Found result : " + JSON.stringify(result));
        res.json(Object.assign({}, { data: result}))
    }

    allWards() {
        
    }
}
