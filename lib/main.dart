import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Container(
            color: Colors.red,
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
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          onChanged: (value) {},
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          controller: t1,
                          decoration: const InputDecoration(
                              hintText: "Name",
                              hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal),
                              prefixIcon: Icon(Icons.account_circle_rounded)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
