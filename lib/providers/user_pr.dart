import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_rivaan/models/user_model.dart';
import 'package:instagram_rivaan/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel _userModel = UserModel(
    email: '',
    uid: '',
    photoUrl: '',
    userName: '',
    bio: '',
    followers: [],
    following: [],
  );
  UserModel get getUser => _userModel;

  Future<void> refreshUser() async {
    UserModel userModel = await AuthMethods().getUserDetails();
    _userModel = userModel;
    notifyListeners();
  }
}
