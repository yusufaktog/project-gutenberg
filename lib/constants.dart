import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'main.dart';

const coverThumb = "https://gutenberg.org/";
const searchIcon = Icon(Icons.search);
const preferredAppBarHeight = Size.fromHeight(100);
const Icon logoutIcon = Icon(
  IconData(0xf88b, fontFamily: 'MaterialIcons'),
  color: Colors.red,
);
const libraryIcon = Icon(Icons.local_library_sharp);

var routes = {
  LoginPage.routeName: (context) => const LoginPage(),
};

FirebaseOptions firebaseConfig = const FirebaseOptions(
  apiKey: "AIzaSyDgVA5P5rJbfjeziAQQIJeNw5V1wEvTEoA",
  authDomain: "project-gutenberg-5669d.firebaseapp.com",
  projectId: "project-gutenberg-5669d",
  storageBucket: "project-gutenberg-5669d.appspot.com",
  messagingSenderId: "317129222736",
  appId: "1:317129222736:android:11287696744ffb375b3f55",
);
