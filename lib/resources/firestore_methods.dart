import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_rivaan/models/post_model.dart';
import 'package:instagram_rivaan/resources/storage_methods.dart';
import 'package:instagram_rivaan/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUserName() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    //print(snapshot.data());
    return snapshot;
  }

  //====================================
  Future<String> uploadPost({
    required String uid,
    required String description,
    required Uint8List file,
    required String userName,
    required String profImage,
  }) async {
    String res = 'Some error occurred';
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        childName: 'posts',
        file: file,
        isPost: true,
      );
      String postId = const Uuid().v1();
      PostModel postModel = PostModel(
        description: description,
        userName: userName,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      await firestore.collection('posts').doc(postId).set(postModel.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //==========================================
  Future<void> likePost(
      {required String postId,
      required String uid,
      required List likes}) async {
    if (likes.contains(uid)) {
      await firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  //======================================
  Future<String> postComment({
    required String postId,
    required String text,
    required String uid,
    required String name,
    required String profilePic,
    required BuildContext context,
  }) async {
    String res = 'Some error occurred';
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        Utils().showSnackBar(context, 'Please add a comment');
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //============================================
  Future<void> deletePost(String postId) async {
    try {
      await firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //============================================
  Future<void> followUser(
      {required String uid, required String followId}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      List following = (documentSnapshot.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
  //================================

}
