# namma_chennai

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## API Reference

- Endpoint - /platform
- Method - GET
- Request- none
- Response - Welcome to Citizen Engagement platform API v1 $request device
- Auth - no

### auth.service

- Endpoint  - /token/userid
- Method - POST
- Request - userId
- Response - user details (most importantly token to authenticate)
- Auth - will authenticate if login goes well. <br/> <br/>
 
- Endpoint  - /verify
- Method - POST
- Request - userId
- Response - verified message
- Auth - yes

### location.service

- Endpoint  - /findward
- Method - POST
- Request - latitude longitude
- Response - ward details
- Auth - no

### user.service

- Endpoint  - /user
- Method - GET
- Request - userid from logged state
- Response- user details
- Auth - Yes
