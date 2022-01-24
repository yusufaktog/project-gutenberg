import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_gutenberg/book_card.dart';

import 'book_details.dart';

class BookshelfPage extends StatefulWidget {
  final User? user;

  const BookshelfPage({Key? key, this.user}) : super(key: key);

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Center(child: Text("My Bookshelf")),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Bookshelves").doc(_user!.uid).collection("Bookshelf").snapshots(),
                builder: (context, snapshot) {
                  return snapshot.connectionState != ConnectionState.waiting
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, index) {
                            var books = snapshot.data!.docs;
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DetailedBookPage(
                                      id: books[index]["id"],
                                      title: books[index]["title"],
                                      bookmark: books[index]["bookmark"],
                                      imageUrl: books[index]["image_url"],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                                child: BookCard(
                                  user: _user,
                                  book: Book.previewed(books[index]["image_url"], books[index]["title"], books[index]["author"],
                                      books[index]["bookmark"], books[index]["id"]),
                                  inBookShelf: true,
                                ),
                              ),
                            );
                          })
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                }),
          ),
        ),
      ),
    );
  }
}
