import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_gutenberg/database/auth.dart';
import 'package:project_gutenberg/search_book_page.dart';

import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(
    MaterialApp(
      initialRoute: LoginPage.routeName,
      routes: routes,
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
  late String _name = "";
  late String _password = "";
  late String _email = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.grey,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
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
                          hintText: "email",
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 25,
                              fontWeight: FontWeight.normal),
                          prefixIcon: Icon(Icons.account_circle_rounded),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
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
                          hintText: "password",
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 25,
                              fontWeight: FontWeight.normal),
                          prefixIcon: Icon(Icons.account_circle_rounded),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
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
                          hintText: "name",
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 25,
                              fontWeight: FontWeight.normal),
                          prefixIcon: Icon(Icons.account_circle_rounded),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              _authService
                                  .signIn(_email, _password)
                                  .then((user) => {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SearchBookPage(
                                                user: user,
                                              ),
                                            ),
                                            (route) => false)
                                      });
                            },
                            child: const Text("LOGIN"),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              _authService.createUser(_name, _password, _email);
                            },
                            child: const Text("SIGN UP"),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              _authService
                                  .signIn("alicem@gmail.com", "alicem123")
                                  .then((user) => {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SearchBookPage(
                                                user: user,
                                              ),
                                            ),
                                            (route) => false)
                                      });
                            },
                            child: const Text("TEST"),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
