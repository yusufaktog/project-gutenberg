import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'book_card.dart';
import 'constants.dart';

Future<void> main() async {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

TextEditingController t1 = TextEditingController();

class _MyAppState extends State<MyApp> {
  late List<Card> results = [];

  void searchBook(String query) async {
    query = query.trim().replaceAll(' ', '+');
    var searchUrlFormat =
        "https://gutenberg.org/ebooks/search/?query=$query&submit_search=Go%21";
    print(searchUrlFormat);
    var parsedUrl = Uri.parse(searchUrlFormat);

    final response = await http.Client().get(
      parsedUrl,
    );
    var str = response.body;
    var document = parse(str);

    var pageContent = document.getElementsByClassName("booklink");
    pageContent.forEach((element) {
      String coverThumb = "";
      String title = "";
      String author = "";
      try {
        title = element.getElementsByClassName("title")[0].text;
        author = element.getElementsByClassName("subtitle")[0].text;
        coverThumb = "https://gutenberg.org/" +
            element.getElementsByClassName("cover-thumb")[0].attributes["src"]!;
        results.add(bookCardBuilder(Book.previewed(coverThumb, title, author)));
        print("cover: " +
            coverThumb +
            "\ntitle: " +
            title +
            "\nauthor: " +
            author);
      } on RangeError {
        setState(() {
          results.add(bookCardBuilder(Book.previewed("", title, author)));
        });
        print('Content of book is corrupted!');
      }
    });
    print('----------------');
  }

  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: preferredAppBarHeight,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: TextField(
                controller: t1,
                decoration: const InputDecoration(
                  hintText: 'Search',
                ),
                onChanged: (value) {
                  print("CHANGE______________________________");
                  setState(() {
                    results.clear();
                    searchBook(value);
                  });
                },
                onEditingComplete: () {},
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      searchBook(t1.text);
                    });
                    t1.clear();
                  },
                  icon: icon),
            ),
          ],
        ),
      ),
      body: results.isNotEmpty
          ? SingleChildScrollView(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print(results.length);
                      },
                      child: results[index],
                    );
                  }),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
