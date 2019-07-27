import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_chennai/locale/all_translations.dart';
import 'package:hello_chennai/model/orgs.dart';
import 'package:hello_chennai/utils/shared_prefs.dart';
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

  List<Widget> documentList = [];
  void getFilePath() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.ANY);
      if (filePath == '') {
        return;
      }
      setState(() {
        documentList
            .add(Text((documentList.length + 1).toString() + ". " + filePath));
      });
      print(filePath);
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
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: false,
          title: Text(allTranslations.text('translation_24')),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
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
                        labelText: allTranslations.text('translation_25'),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                      autofocus: false),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(5),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 2.0,
                            style: BorderStyle.solid,
                            color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<OrgType>(
                        isExpanded: true,
                        hint: Text(allTranslations.text('translation_26')),
                        items: <OrgType>[
                          OrgType.GOVERNMENT,
                          OrgType.NGO,
                          OrgType.PRIVATE,
                          OrgType.OTHER
                        ].map((OrgType value) {
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
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 2.0,
                          style: BorderStyle.solid,
                          color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: documentList),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: OutlineButton(
                          color: Colors.blue,
                          borderSide: BorderSide(
                              width: 2.0,
                              style: BorderStyle.solid,
                              color: Colors.blue),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          onPressed: () {
                            getFilePath();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  allTranslations.text('translation_27'),
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  allTranslations.text('translation_43'),
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))),
                Container(
                    margin: EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          onPressed: () {
                            saveOrg();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  allTranslations.text('translation_28'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  allTranslations.text('translation_29'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))),
              ],
            ),
          ),
        ));
  }
}
