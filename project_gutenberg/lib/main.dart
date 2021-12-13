import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

void SearchBooks() async {
  List<String> informationBlock = [];
  List<String> clearData = [];

  //for (int i = 1; i < 60002; i++) {
  var uri = "https://gutenberg.org/ebooks/60600";
  var search_url_format =
      "https://gutenberg.org/ebooks/search/?query=$newstr&submit_search=Go%21";
  var parsedUrl = Uri.parse(search_url_format);

  final response = await http.Client().get(
    parsedUrl,
  );
  var str = response.body;
  var document = parse(str);

  try {
    var pageContent = document.getElementsByClassName("booklink");
    pageContent.forEach((element) {
      print(element
          .getElementsByClassName("cover-thumb")[0]
          .attributes["src"]); //src'den donen kısıma www.gutenber.org eklenecek
      //print(element.getElementsByClassName("title")[0].text);
      //print(element.getElementsByClassName("subtitle")[0].text);
    });
  } on RangeError {
    print('Content of book is corrupted!');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

TextEditingController t1 = TextEditingController();
late String newstr = t1.text.trim().replaceAll(' ', '+');

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: TextField(
              controller: t1,
              decoration: InputDecoration(
                hintText: 'Search',
              ),
            ),
          ),
          Expanded(
              child: IconButton(
                  onPressed: () {
                    SearchBooks();
                    print(newstr);
                    t1.clear();
                  },
                  icon: icon))
          //IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
    );
  }
}

const icon = Icon(Icons.search);