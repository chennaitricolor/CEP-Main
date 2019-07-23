# Hello Chennai

For the people, By the people

## REST API Documentation

```https://us-central1-tech-for-cities.cloudfunctions.net/api```

> ### Publish Micro Apps

#### To publish micro app [Click Here](https://tech-for-cities.web.app/publish)

### Prequisites
 
- Must be a registered user of ```Hello Chennai``` 
- Should support **Tamil, English and Tanglish**
- Should provide **Micro-app icon url, app url, title and description**
- Download [signin.html](https://raw.githubusercontent.com/chennaitricolor/SmartCityCEP/dev/apiV1/public/signin.html) (should be placed along with index.html) from the repository and add to app root, it is required  if you would like to access data from platform.

### Access data from Platform

Within your micro-app, you can access the user information anywhere using the below code snippet.
 
``` let userInformation = localStorage.getItem("user"); ```

##### How it works (with Example)

Sample Micro App : **[Demo Micro-App](https://tech-for-cities.web.app)**

- While opening the micro app, initial hit will goes here :

```https://tech-for-cities.web.app/signin.html?token=lzc1FLB9GoWA28E2jcUf5agiJj12```

- Once the token is validated, it will be redirected here :

```https://tech-for-cities.web.app``` 

> ### Ward API


| URL           | Method        |
| ------------- | ------------- |
| /position  | POST  |

Get ward and zone information by providing latitude and longitude.

### Request Body

```json
{
	"lat" : "13.1133903",
	"long" : "80.2871213"
}
```
### Response

```json
{
    "data": {
        "wardNo": "51",
        "zoneInfo": "Zone 5 Royapuram"
    }
}
```
