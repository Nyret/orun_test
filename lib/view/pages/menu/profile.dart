import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences properties;

  TextEditingController editNameController;
  TextEditingController editLastNameController;
  TextEditingController editEmailController;

  File avatarFile;

  String uid = '';
  String name = '';
  String lastName = '';
  String email = '';
  String avatarUrl = '';
  String admissionType = '';

  @override
  void initState() {
    super.initState();
    readProperties();
  }

  void readProperties() async {
    properties = await SharedPreferences.getInstance();
    uid = properties.getString('uid') ?? '';
    name = properties.getString('name') ?? '';
    lastName = properties.getString('lastName') ?? '';
    email = properties.getString('email') ?? '';
    avatarUrl = properties.getString('avatarUrl') ?? '';
    admissionType = properties.getString('admissionType') ?? '';

    editNameController = new TextEditingController(text: name);
    editLastNameController = new TextEditingController(text: lastName);
    editEmailController = new TextEditingController(text: email);

    setState(() {});
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      avatarFile = image;
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = uid;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarFile);

    Uri downloadUrl = (await uploadTask.future).downloadUrl;
    avatarUrl = downloadUrl.toString();

    Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'avatarUrl': avatarUrl}).then((data) async {
      properties.setString('avatarUrl', avatarUrl);
      setState(() {});
    }).catchError((err) {
      setState(() {});
    });
  }

  Future updateUserInfo() async {
    Firestore.instance.collection('users').document(uid).updateData({
      'name': editNameController.text,
      'lastName': editLastNameController.text
    }).then((data) async {
      properties.setString('name', editNameController.text);
      properties.setString('lastName', editLastNameController.text);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets textFieldsPadding =
        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0);

    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Column(children: <Widget>[
          new GestureDetector(
              onTap: getImage,
              child: new Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                  height: 150.0,
                  child: new FittedBox(
                      fit: BoxFit.fill,
                      child: new CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                          child: avatarUrl == null || avatarUrl == ""
                              ? Icon(Icons.person)
                              : new Text(""))))),
          new Container(
              child: new Column(children: <Widget>[
            new Container(
              padding: textFieldsPadding,
              child: new TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: editNameController,
                decoration: new InputDecoration(
                    labelText: "Nombre de usuario",
                    border: new OutlineInputBorder()),
              ),
            ),
            new Container(
              padding: textFieldsPadding,
              child: new TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: editLastNameController,
                decoration: new InputDecoration(
                    labelText: "Apellido", border: new OutlineInputBorder()),
              ),
            ),
            new Container(
                padding: textFieldsPadding,
                child: new TextField(
                  controller: editEmailController,
                  enabled: false,
                  decoration: new InputDecoration(
                      labelText: "Email", border: new OutlineInputBorder()),
                ))
          ]))
        ]),
        floatingActionButton: floatingUpdateButton());
  }

  Widget floatingUpdateButton() {
    return new Container(
      child: FloatingActionButton(
        onPressed: updateUserInfo,
        tooltip: "Actualizar",
        child: Icon(Icons.cloud_upload),
      ),
    );
  }
}
