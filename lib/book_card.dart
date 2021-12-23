import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database/crud.dart';

class Book {
  String coverImageUrl;
  String title;
  String author;
  int? bookmark;
  String? id;

  Book.previewed(
      this.coverImageUrl, this.title, this.author, this.bookmark, this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          coverImageUrl == other.coverImageUrl;

  @override
  int get hashCode => coverImageUrl.hashCode;
}

class BookCard extends StatefulWidget {
  final Book book;
  final User? user;

  const BookCard({Key? key, required this.book, required this.user})
      : super(key: key);

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  late bool _hasBook;

  @override
  void initState() {
    super.initState();
    hasBook();
  }

  @override
  Card build(BuildContext context) {
    return Card(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: widget.book.coverImageUrl.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(widget.book.coverImageUrl),
                    )
                  : Image.asset("assets/no_image.png"),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: <Widget>[
                  Text(
                    widget.book.title,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      widget.book.author,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Card(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: TextButton(
                  onPressed: () async {
                    _hasBook =
                        await DatabaseHelper.bookshelfContains(widget.book.id!)
                            .then((value) {
                      return value;
                    });
                    _hasBook
                        ? DatabaseHelper.removeBook(widget.book.id!)
                        : DatabaseHelper.addBook(widget.book);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.0),
                    child: Text(
                      "Add \n& Remove \nBook",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void hasBook() async {
    _hasBook =
        await DatabaseHelper.bookshelfContains(widget.book.id!).then((value) {
      return value;
    });
  }
}
