import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:project_gutenberg/database/crud.dart';

class BookReader extends StatefulWidget {
  final String id;
  final String title;
  final int bookmark;

  const BookReader(
      {Key? key, required this.id, required this.title, required this.bookmark})
      : super(key: key);

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  late IndexedScrollController _controller;

  List<String> pages = [];

  Future<void> getBookContent() async {
    var contentLink =
        "https://gutenberg.org/cache/epub/${widget.id}/pg${widget.id}-images.html";
    print(contentLink);
    var parsedUrl = Uri.parse(contentLink);
    final response = await http.Client().get(
      parsedUrl,
    );

    var document = parse(response.body);

    var elements = document.getElementsByTagName("p");
    for (var element in elements) {
      setState(() {
        if (element.text.isNotEmpty) {
          pages.add(element.text);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBookContent();
    _controller = IndexedScrollController(initialIndex: widget.bookmark);
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
        body: pages.isNotEmpty
            ? IndexedListView.builder(
                controller: _controller,
                minItemCount: 0,
                maxItemCount: pages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          pages[index],
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        IconButton(
                          iconSize: 15,
                          tooltip: "Add Bookmark",
                          splashRadius: 10.0,
                          icon: const Icon(
                            Icons.add,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            try {
                              DatabaseHelper.updateBookmark(widget.id, index);
                            } on FirebaseException {
                              print(
                                  "You do not have this book in your bookshelf");
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
