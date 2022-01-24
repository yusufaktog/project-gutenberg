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
  final String imageUrl;
  int bookmark;

  DetailedBookPage({Key? key, required this.id, required this.title, required this.bookmark, required this.imageUrl}) : super(key: key);

  @override
  State<DetailedBookPage> createState() => _DetailedBookPageState();
}

class _DetailedBookPageState extends State<DetailedBookPage> {
  late Map<String, String> details = {};
  late List<String> keys = [];

  Future<void> getBookDetails() async {
    var searchUrlFormat = "https://gutenberg.org/ebooks/${widget.id}";

    var parsedUrl = Uri.parse(searchUrlFormat);

    final response = await http.Client().get(
      parsedUrl,
    );

    var document = parse(response.body);

    var pageContent = document.getElementsByClassName("bibrec");

    var rows = pageContent[0].getElementsByTagName('tr');

    int duplicatedKeyIndex = 1;

    for (var element in rows) {
      try {
        var key = element.getElementsByTagName('th')[0].text.trim();
        var value = element.getElementsByTagName('td')[0].text.trim();
        setState(() {
          if (!details.containsKey(key)) {
            details[key] = value;
            keys.add(key);
            duplicatedKeyIndex = 2;
          } else {
            var duplicatedKey = key + " " + duplicatedKeyIndex.toString();
            details[duplicatedKey] = value;
            duplicatedKeyIndex++;
            keys.add(duplicatedKey);
          }
        });
      } on RangeError {}
      //index++;
    }
  }

  void getBookmark() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    final User? user = _firebaseAuth.currentUser;
    String uid = user!.uid;
    int bookmark = 0;

    try {
      await FirebaseFirestore.instance.collection("Bookshelves").doc(uid).collection("Bookshelf").doc(widget.id).snapshots().forEach((element) {
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
    getBookDetails();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: widget.imageUrl.isNotEmpty
                          ? Image.network("https://gutenberg.org/cache/epub/${widget.id}/pg${widget.id}.cover.medium.jpg")
                          : Image.asset("assets/no_image.png"),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: TextButton(
                              onPressed: () {
                                if (widget.imageUrl.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: RichText(
                                          text: TextSpan(
                                              text: "This book is an audio book, which means that it can not be read "
                                                  "please checkout the link below:\nhttps://gutenberg.org/ebooks/${widget.id}"),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Center(
                                              child: Text('OK'),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  getBookmark();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BookReader(id: widget.id, title: widget.title, bookmark: widget.bookmark),
                                    ),
                                  );
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
                                child: Text("Read Book"),
                              ),
                            ),
                          ),
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
                  ? ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        return Card(
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
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
