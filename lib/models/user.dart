//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  
  String uid;
  String name;
  String email;
  String profileImageUrl;
  String tokenId;
  String loggedInVia;

  UserModel({
    
    this.uid,
    this.email,
    this.name,
    this.profileImageUrl,
    this.loggedInVia,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      loggedInVia: data['loggedInVia'],
    );
  } 

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      loggedInVia: data['loggedInVia'],
    );
  }
}

