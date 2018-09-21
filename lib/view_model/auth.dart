import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orun_test/view_model/baseAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orun_test/view_model/utils.dart';

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  SharedPreferences properties;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> createUser(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  void createUserIfNotExist() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null) {
      properties = await SharedPreferences.getInstance();
      final Utils utils = new Utils();
      List<DocumentSnapshot> documents = await utils.getUserDocument(user.uid);
      if (documents.length == 0) {
        Firestore.instance.collection('users').document(user.uid).setData({
          'uid': user.uid,
          'name': user.displayName,
          'lastName': '',
          'email': user.email,
          'avatarUrl': user.photoUrl,
          'admissionType': ''
        });
        //si el usuario no existe almacenamos los datos desde firebase
        properties.setString('uid', user.uid);
        properties.setString('name', user.displayName);
        properties.setString('lastName', '');
        properties.setString('email', user.email);
        properties.setString('avatarUrl', user.photoUrl);
        properties.setString('admissionType', '');
      } else {
        //si el usuario esta creado en db obtenemos los datos desde firestore
        //almacena en disco los datos del usuario
        documents = await utils.getUserDocument(user.uid);
        properties.setString('uid', documents[0]['uid']);
        properties.setString('name', documents[0]['name']);
        properties.setString('lastName', documents[0]['lastName']);
        properties.setString('email', documents[0]['email']);
        properties.setString('avatarUrl', documents[0]['avatarUrl']);
        properties.setString('admissionType', documents[0]['admissionType']);
      }
    }
  }
}
