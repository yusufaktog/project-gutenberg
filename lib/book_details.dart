import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:project_gutenberg/read_book_page.dart';

class DetailedBookPage extends StatefulWidget {
  final String id;
  final String title;
  int bookmark;

  DetailedBookPage(
      {Key? key, required this.id, required this.title, required this.bookmark})
      : super(key: key);

  @override
  State<DetailedBookPage> createState() => _DetailedBookPageState();
}

class _DetailedBookPageState extends State<DetailedBookPage> {
  late Map<String, String> details = {};
  late List<String> keys = [];

  Future<void> searchBook() async {
    var searchUrlFormat = "https://gutenberg.org/ebooks/${widget.id}";
    print("book link ==> " + searchUrlFormat);
    var parsedUrl = Uri.parse(searchUrlFormat);

    final response = await http.Client().get(
      parsedUrl,
    );

    var document = parse(response.body);

    var pageContent = document.getElementsByClassName("bibrec");

    var rows = pageContent[0].getElementsByTagName('tr');

    int index = 0;
    int duplicatedKeyIndex = 1;

    for (var element in rows) {
      try {
        var key = rows[index].getElementsByTagName('th')[0].text.trim();
        var value = rows[index].getElementsByTagName('td')[0].text.trim();
        setState(() {
          if (!details.containsKey(key)) {
            details[key] = value;
            keys.add(key);
            duplicatedKeyIndex = 1;
          } else {
            var duplicatedKey = key + " " + duplicatedKeyIndex.toString();
            details[duplicatedKey] = value;
            duplicatedKeyIndex++;
            keys.add(duplicatedKey);
          }
        });
      } on RangeError {
        print('Content of book is corrupted!');
      }
      index++;
    }
  }

  void getBookMark() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;
    String uid = user!.uid;
    int bookmark = 0;

    try {
      await FirebaseFirestore.instance
          .collection("Bookshelves")
          .doc(uid)
          .collection("Bookshelf")
          .doc(widget.id)
          .snapshots()
          .forEach((element) {
        if (element["id"] == widget.id) {
          setState(() {
            bookmark = element["bookmark"];
          });
        }
        widget.bookmark = bookmark;
      });
    } on Error {
      //widget.bookmark = bookmark; // if the book does not exist in the bookshelf
    }
  }

  @override
  void initState() {
    super.initState();
    searchBook();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(widget.title, overflow: TextOverflow.ellipsis),
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.network(
                        "https://gutenberg.org/cache/epub/${widget.id}/pg${widget.id}.cover.medium.jpg"),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Card(
                          color: Colors.red,
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextButton(
                            onPressed: () {
                              getBookMark();
                              print("bookmark updated:${widget.bookmark}");

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BookReader(
                                      id: widget.id,
                                      title: widget.title,
                                      bookmark: widget.bookmark),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 50),
                              child: Text("Read Book"),
                            ),
                          ),
                        ),
                        /*Card(
                          color: Colors.red,
                          margin: const EdgeInsets.all(8.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: TextButton(
                            onPressed: () async {
                              await DatabaseHelper.bookshelfContains(
                                          widget.id)
                                      .then((value) {
                                return value;
                              })
                                  ? DatabaseHelper.removeBook(widget.id)
                                  : DatabaseHelper.addBook(widget.book);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 50),
                              child: Text("Add / Remove BooK"),
                            ),
                          ),
                        ),*/
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("BOOKMARK:${widget.bookmark}"),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            details.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Card(
                            color: Colors.grey[600],
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  FittedBox(
                                    child: Text(
                                      keys[index] + " : ",
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    details[keys[index]]!,
                                    maxLines: 3,
                                  ))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}
