import 'dart:async';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:project_gutenberg/constants.dart';
import 'package:project_gutenberg/user.dart';

import 'book_card.dart';
import 'book_details.dart';
import 'bookshelf_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

TextEditingController t1 = TextEditingController();

class _MyAppState extends State<MyApp> {
  User user = User(name: "Yusuf Aktoğ", email: "yusufaktok@gmail.com");
  late List<BookCard> results = [];
  Timer? _debounce;

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
      Book book;
      try {
        title = element.getElementsByClassName("title")[0].text;
        author = element.getElementsByClassName("subtitle")[0].text;
        coverThumb = "https://gutenberg.org/" +
            element.getElementsByClassName("cover-thumb")[0].attributes["src"]!;

        book = Book.previewed(coverThumb, title, author);
        setState(() {
          results.add(BookCard(
            user: user,
            book: book,
          ));
        });
      } on RangeError {
        setState(() {
          book = Book.previewed(coverThumb, title, author);
        });
        print('Content of book is corrupted!');
      }
    });
    print('----------------');
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      searchBook("");
      results.clear();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.red[400],
                      child: Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    accountName: Text(user.name),
                    accountEmail: Text(user.email)),
                const DrawerHeader(
                  child: Center(
                    child: Text('Email'),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  tileColor: Colors.blue,
                  title: const Text('Bookshelf'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BookshelfPage(
                          user: user,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                ListTile(
                  title: const Text('Log Out'),
                  tileColor: Colors.red,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BookshelfPage(
                          user: user,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.red),
          bottom: PreferredSize(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    controller: t1,
                    decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          color: Color(0xFFA0A0A0),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        filled: true,
                        fillColor: const Color(0xFFF0F0F6),
                        focusColor: const Color(0xFFF0F0F6),
                        prefixIcon: IconButton(
                          icon: searchIcon,
                          onPressed: () {
                            setState(() {
                              results.clear();
                              searchBook(t1.text);
                            });
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            t1.clear();
                          },
                        )),
                    onChanged: (value) {
                      setState(() {
                        results.clear();
                        if (_debounce?.isActive ?? false) _debounce?.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 1000), () {
                          searchBook(value);
                        });
                      });
                    },
                  ),
                )
              ],
            ),
            preferredSize: const Size.fromHeight(80),
          ),
        ),
        body: results.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailedBookPage(
                                id: results[index]
                                    .book
                                    .coverImageUrl
                                    .split('/')[6],
                                title: results[index].book.title //split et
                                ),
                          ),
                        );
                      },
                      child: results[index],
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
