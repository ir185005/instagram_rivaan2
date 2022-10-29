import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_rivaan/screens/feeds_scr.dart';
import 'package:instagram_rivaan/screens/profile_scr.dart';
import 'package:instagram_rivaan/screens/search_scr.dart';

import '../screens/add_post_scr.dart';

const unsplashImage = 'https://images.unsplash.com/photo-1661956600684-'
    '97d3a4320e45?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxlZ'
    'Gl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=800&q=60';
const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedsScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(
    child: Text('Favorite'),
  ),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
