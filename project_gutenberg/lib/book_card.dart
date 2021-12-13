import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Book {
  String coverImageUrl;
  String title;
  String author;
  String? id;
  int? downloadCount;
  int? releaseYear;
  String? language;

  Book.previewed(this.coverImageUrl, this.title, this.author);

  Book.detailed(this.coverImageUrl, this.id, this.downloadCount,
      this.releaseYear, this.title, this.author, this.language);
}

Card bookCardBuilder(Book book) {
  return Card(
    child: Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: book.coverImageUrl.isNotEmpty
              ? Image.network(book.coverImageUrl)
              : Image.asset("no_image.png"),
        ),
        Expanded(
          flex: 6,
          child: Column(
            children: <Widget>[
              Text(
                book.title,
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
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  book.author,
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
              onPressed: () {
                print(book.title);
              },
              child: const Text(
                "Add To Bookshelf",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
