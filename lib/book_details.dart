import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:project_gutenberg/read_book_page.dart';

class DetailedBookPage extends StatefulWidget {
  final String id;
  final String title;
  final int bookmark;

  const DetailedBookPage(
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

  @override
  void initState() {
    super.initState();
    searchBook();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                                child: Text("ADD BOOK"),
                              ),
                            ),
                          ),
                          Card(
                            color: Colors.red,
                            margin: const EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: TextButton(
                              onPressed: () {},
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 50),
                                child: Text("READ BOOK"),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("BOOKMARK: 12 "),
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
                      shrinkWrap: true,
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            Card(
                              color: Colors.black54,
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    keys[index] + ": " + details[keys[index]]!),
                              ),
                            )
                          ],
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
