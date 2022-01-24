import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_gutenberg/database/auth.dart';
import 'package:project_gutenberg/search_book_page.dart';

import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.routeName,
      routes: routes,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('tr', ''),
      ],
    ),
  );
}

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

TextEditingController t1 = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  String _name = "";
  String _password = "";
  String _email = "";
  String currentLocale = 'en';

  bool hasAccount = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Virtual Bookshelf"),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  !hasAccount
                      ? Card(
                          elevation: 0.0,
                          color: Colors.grey,
                          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onChanged: (value) {
                                _name = value;
                              },
                              cursorColor: Colors.black,
                              cursorHeight: 25,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(gapPadding: 100.0, borderRadius: BorderRadius.all(Radius.circular(10))),
                                hintText: "name",
                                hintStyle: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.normal),
                                prefixIcon: Icon(Icons.account_circle_rounded),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Card(
                    elevation: 0.0,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          _email = value;
                        },
                        cursorColor: Colors.black,
                        cursorHeight: 25,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(gapPadding: 100.0, borderRadius: BorderRadius.all(Radius.circular(10))),
                          hintText: "email",
                          hintStyle: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.normal),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.0,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          _password = value;
                        },
                        cursorColor: Colors.black,
                        cursorHeight: 25,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(gapPadding: 100.0, borderRadius: BorderRadius.all(Radius.circular(10))),
                          hintText: "password",
                          hintStyle: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.normal),
                          prefixIcon: Icon(Icons.security),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.grey[800],
                        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () async {
                              var authSuccess = true;
                              if (hasAccount) {
                                await _authService.signIn(_email, _password).catchError((e) {
                                  Fluttertoast.showToast(msg: e.toString().split("]")[1], webShowClose: true, webPosition: "center");
                                  authSuccess = false;
                                });
                              } else {
                                if (_name.isEmpty) {
                                  Fluttertoast.showToast(msg: "Field 'name' can not be empty!", webShowClose: true, webPosition: "center");
                                }
                                await _authService.createUser(_name, _password, _email).catchError((e) {
                                  Fluttertoast.showToast(msg: e.toString().split("]")[1], webShowClose: true, webPosition: "center");
                                  authSuccess = false;
                                });
                              }
                              if (authSuccess) {
                                buildPushAndRemoveUntil(context, FirebaseAuth.instance.currentUser);
                              }
                            },
                            child: Text(
                              hasAccount ? "LOGIN" : "SIGN UP",
                              style: TextStyle(color: Colors.red[400], fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        hasAccount = !hasAccount;
                      });
                    },
                    child: Text(
                      hasAccount ? "SIGN UP " : "Already have an account ? ",
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (currentLocale == 'en') {
                          currentLocale = 'tr';

                          return;
                        }
                        currentLocale = 'en';
                      });
                    },
                    child: Text(currentLocale.toUpperCase()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildPushAndRemoveUntil(BuildContext context, User? user) {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => SearchBookPage(
            user: user,
          ),
        ),
        (route) => false);
  }
}
