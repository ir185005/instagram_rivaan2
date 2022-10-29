import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_rivaan/models/user_model.dart';
import 'package:instagram_rivaan/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
//=================================
  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl = await StorageMethods().uploadImageToStorage(
          childName: 'profilePics',
          file: file,
          isPost: false,
        );

        UserModel userModel = UserModel(
          email: email,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          userName: userName,
          bio: bio,
          followers: [],
          following: [],
        );
        await fireStore.collection('users').doc(cred.user!.uid).set(
              userModel.toJson(),
            );
        res = 'success';
      }
    } catch (e) {
      res = e.toString();
      print(e);
    }
    return res;
  }

  //===============================
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = 'Please fill in all the fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //=======================================
  Future<UserModel> getUserDetails() async {
    User currentUser = auth.currentUser!;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    return UserModel.fromSnap(snap);
  }

  //===========================
  Future<void> signOut() async {
    await auth.signOut();
  }
}
