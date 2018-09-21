import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
  Future<List<DocumentSnapshot>> getUserDocument(userUid) async {
    QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: userUid)
        .getDocuments();

    return result.documents;
  }
}
