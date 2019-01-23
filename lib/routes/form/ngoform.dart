import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:namma_chennai/model/orgs.dart';
import 'package:namma_chennai/utils/shared_prefs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

SharedPrefs _sharedPrefs = new SharedPrefs();
Firestore db = Firestore.instance;
CollectionReference collectionRef = db.collection('orgs');
StorageReference storageReference = FirebaseStorage.instance.ref();

class NGOForm extends StatefulWidget {
  @override
  NGOFormState createState() => NGOFormState();
}

class NGOFormState extends State<NGOForm> {
  String userId;
  Orgs currentOrg;
  OrgType selectedOrgType;
  String filePath;
  bool isUploaded = false;

  saveOrg() {
    currentOrg.userId = userId;
    collectionRef.document().setData(currentOrg.toJson()).catchError((e) {
      print(e);
    });
    Navigator.pop(context);
  }

  void getFilePath() async {
   try {
      String filePath = await FilePicker.getFilePath(type: FileType.ANY);
      if (filePath == '') {
        return;
      }
      isUploaded = false;
      this.filePath = filePath;
      uploadFile();
    } on Exception catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  Future<Null> uploadFile() async {
    final ByteData bytes = await rootBundle.load(filePath);
    final Directory tempDir = Directory.systemTemp;
    final String fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    final File file = File('${tempDir.path}/$fileName');
    file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    var url = downloadUrl.toString();
    currentOrg.orgDocUrl = url;
    setState(() {
      isUploaded = true;
    });
}

  @override
  void initState() {
    super.initState();
    _sharedPrefs.getApplicationSavedInformation("loggedinuser").then((val) {
      userId = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: false,
        title: Text('Add Org'),
      ),
      body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30),
                  width: 300.0,
                  child: TextField(
                      keyboardType: TextInputType.text,
                      maxLength: 100,
                      textInputAction: TextInputAction.next,
                      onChanged: (String name) {
                        if (currentOrg == null) {
                          currentOrg = new Orgs();
                        }
                        currentOrg.orgName = name;
                      },
                      decoration: InputDecoration(
                        labelText: "Organization Name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                      autofocus: true),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            DropdownButton<OrgType>(
              hint: Text("Select Organization Type"),
              items: <OrgType>[OrgType.GOVERNMENT, OrgType.NGO, OrgType.PRIVATE, OrgType.OTHER].map((OrgType value) {
                return DropdownMenuItem<OrgType>(
                  value: value,
                  child: Text(value.toString().substring(8)),
                );
              }).toList(),
              value: selectedOrgType,
              onChanged: (OrgType value) {
                if (currentOrg == null) {
                  currentOrg = new Orgs();
                }
                currentOrg.orgType = value.toString();
                setState(() {
                  selectedOrgType = value;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            (isUploaded == false) ?
            FlatButton(
              color: Colors.red,
              onPressed: () {
                getFilePath();
              },
              shape: new RoundedRectangleBorder(
                borderRadius:
                    new BorderRadius.circular(30.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 58.0),
                child: Text(
                  'Document Upload',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ) : Column(
                  children: <Widget>[
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 50.0,
                    ),
                    Text(
                      "Document Uploaded!",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () {
                saveOrg();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 58.0),
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}
